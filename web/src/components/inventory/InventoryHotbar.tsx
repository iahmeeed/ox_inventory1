// Made by Karma Developments with Love <3 

import React, { useState } from 'react';
import { getItemUrl, isSlotWithItem } from '../../helpers';
import useNuiEvent from '../../hooks/useNuiEvent';
import { Items } from '../../store/items';
import WeightBar from '../utils/WeightBar';
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';
import { SlotWithItem } from '../../typings';
import SlideUp from '../utils/transitions/SlideUp';
import { getRarityClass } from '../../utils/themeHelper';

const InventoryHotbar: React.FC = () => {
  const [hotbarVisible, setHotbarVisible] = useState(false);
  const items = useAppSelector(selectLeftInventory).items.slice(4, 9);

  //stupid fix for timeout
  const [handle, setHandle] = useState<NodeJS.Timeout>();
  useNuiEvent('toggleHotbar', () => {
    if (hotbarVisible) {
      setHotbarVisible(false);
    } else {
      if (handle) clearTimeout(handle);
      setHotbarVisible(true);
      setHandle(setTimeout(() => setHotbarVisible(false), 3000));
    }
  });

  return (
    <SlideUp in={hotbarVisible}>
      <div className="hotbar-container">
        {items.map((item) => (
          <div
            className={`
              hotbar-item-slot
              ${item.metadata?.rarity === 'uncommon' ? 'uncommon' : item.metadata?.rarity === 'rare' ? 'rare' : item.metadata?.rarity === 'legendary' ? 'legendary' : item.metadata?.rarity === 'epic' ? 'epic' : item.metadata?.rarity === 'unique' ? 'unique' : 'common'}
            `}
            style={{
              backgroundImage: `url(${item?.name ? getItemUrl(item as SlotWithItem) : 'none'})`,
            }}
            key={`hotbar-${item.slot}`}
          >
            {isSlotWithItem(item) && (
              <div
                className="item-slot-wrapper"
                style={{
                  background: '#00000091',
                  position: 'relative',
                  zIndex: -1,
                }}
              >
                <div className="item-slot-info-wrapper w-full flex flex-row justify-between items-center pr-2 text-[10px] h-auto">
                  <div className='flex items-center justify-center px-1.5 h-5 mt-0.5 bg-white/60 rounded-br-md ml-0.5'>
                    <p className='text-black'>{item.slot - 4}</p>
                  </div>
                  {item.metadata?.rarity ? (
                    <p className={`text-xs font-semibold uppercase ${getRarityClass(item.metadata?.rarity)}`}>{item.metadata?.rarity}</p>
                  ) : (
                    <p className='text-xs font-semibold uppercase'>common</p>
                  )}
                </div>
                <div className='relative'>
                  <div className="w-full flex flex-row justify-between">
                    <div className="inventory-slot-label-text max-w-[70%] h-auto">
                      {item.metadata?.label ? item.metadata.label : Items[item.name]?.label || item.name}
                    </div>
                    <div
                      className="justify-end items-end flex max-w-[30%] h-auto pr-[5px] pb-[3px] text-[10px]"
                    >
                      <p>
                        {item.weight > 0
                          ? item.weight >= 1000
                            ? `${(item.weight / 1000).toLocaleString('en-us', {
                                minimumFractionDigits: 2,
                              })}kg `
                            : `${item.weight.toLocaleString('en-us', {
                                minimumFractionDigits: 0,
                              })}g `
                          : ''}
                      </p>
                    </div>
                  </div>
                  <div className="absolute bottom-0 left-0 right-0" style={{ zIndex: 0 }}>
                    {item?.durability !== undefined && <WeightBar percent={item.durability} durability />}
                  </div>
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    </SlideUp>
  );
};

export default InventoryHotbar;
