// Made by Karma Developments with Love <3 

import React, { useCallback, useRef, useState, useMemo } from 'react';
import { DragSource, Inventory, InventoryType, Slot, SlotWithItem } from '../../typings';
import { useDrag, useDragDropManager, useDrop } from 'react-dnd';
import { useAppDispatch, useAppSelector } from '../../store';
import WeightBar from '../utils/WeightBar';
import { onDrop } from '../../dnd/onDrop';
import { Items } from '../../store/items';
import { canCraftItem, canPurchaseItem, getItemUrl, isSlotWithItem } from '../../helpers';
import { onUse } from '../../dnd/onUse';
import { Locale } from '../../store/locale';
import { getRarityClass, getCurrencyColor } from '../../utils/themeHelper';
import { onCraft } from '../../dnd/onCraft';
import useNuiEvent from '../../hooks/useNuiEvent';
import { ItemsPayload } from '../../reducers/refreshSlots';
import { closeTooltip, openTooltip } from '../../store/tooltip';
import { openContextMenu } from '../../store/contextMenu';
import { useMergeRefs } from '@floating-ui/react';
import ClockIcon from '../utils/icons/ClockIcon';
import { TbParachute } from "react-icons/tb";

interface SlotProps {
  inventoryId: Inventory['id'];
  inventoryType: Inventory['type'];
  inventoryGroups: Inventory['groups'];
  item: Slot;
}

interface SettingsProps {
  SpecialSlot: any[];
  balcklistItem: string[];
}

const InventorySlot: React.ForwardRefRenderFunction<HTMLDivElement, SlotProps> = (
  { item, inventoryId, inventoryType, inventoryGroups },
  ref
) => {
  const manager = useDragDropManager();
  const dispatch = useAppDispatch();
  const timerRef = useRef<number | null>(null);
  const [isFading, setIsFading] = useState(false); // Tambahkan state untuk animasi fade
  const settings = useAppSelector((state) => state.settings.data) as SettingsProps;
  const blacklist = settings.balcklistItem;
  const allowedItemsForSlots: { [key: number]: string[] } = {
    1: settings.SpecialSlot[0],
    2: settings.SpecialSlot[1],
    3: settings.SpecialSlot[2],
    4: settings.SpecialSlot[3],
  };

  const canDrag = useCallback(() => {
    return canPurchaseItem(item, { type: inventoryType, groups: inventoryGroups }) && canCraftItem(item, inventoryType);
  }, [item, inventoryType, inventoryGroups]);

  const ingredients = useMemo(() => {
    if (!isSlotWithItem(item) || !item.ingredients) return null;
    return Object.entries(item.ingredients).sort((a, b) => (a[1] as number) - (b[1] as number));
  }, [item]);

  const [{ isDragging }, drag] = useDrag<DragSource, void, { isDragging: boolean }>(
    () => ({
      type: 'SLOT',
      collect: (monitor) => ({
        isDragging: monitor.isDragging(),
      }),
      item: () => {
        if (isSlotWithItem(item, inventoryType !== InventoryType.SHOP)) {
          setIsFading(true); // Aktifkan animasi saat drag dimulai
          return {
            inventory: inventoryType,
            item: {
              name: item.name,
              slot: item.slot,
              price: item.price || 0,
              currency: item.currency || 'money',
              type: item.metadata?.type,
            },
            image: item?.name && `url(${getItemUrl(item) || 'none'})`,
          };
        }
        return null;
      },
      canDrag,
      end: (item, monitor) => {
        setIsFading(false); // Matikan animasi setelah drag selesai
      },
    }),
    [inventoryType, item]
  );

  const [, drop] = useDrop<DragSource, void, { isOver: boolean }>(
    () => ({
      accept: 'SLOT',
      collect: (monitor) => ({
        isOver: monitor.isOver(),
      }),
      drop: (source) => {
        dispatch(closeTooltip());
        setIsFading(false); // Matikan animasi setelah drag selesai
        switch (source.inventory) {
          case InventoryType.CRAFTING:
            onCraft(source, { inventory: inventoryType, item: { slot: item.slot } });
            break;
          default:
            onDrop(source, { inventory: inventoryType, item: { slot: item.slot } });
            break;
        }
      },
      canDrop: (source) => {
        const targetSlot = item.slot;
        const isBlacklisted = blacklist.includes(source.item.name);
        const isWeapon = source.item.type === 'weapon'; // Periksa tipe item
        // console.log(isWeapon);

        if (source.inventory === 'player' && inventoryType === InventoryType.PLAYER) {
          const isTargetSlotRestricted = targetSlot >= 1 && targetSlot <= 4;
          const allowedItems = allowedItemsForSlots[targetSlot] || [];
          const isItemAllowed = allowedItems.includes(source.item.name);
          const isWeaponSlot = targetSlot === 5 || targetSlot === 6; // Tambahkan logika untuk slot 5 dan 6
          const notWeaponSlot = targetSlot >= 7 && targetSlot <= 9; // Tambahkan logika untuk slot 7 sampai 9

          return (
            (source.item.slot !== targetSlot || source.inventory !== inventoryType) &&
            (!isTargetSlotRestricted || (isTargetSlotRestricted && isItemAllowed)) &&
            (!isWeaponSlot || (isWeaponSlot && isWeapon)) &&
            (!notWeaponSlot || (notWeaponSlot && !isWeapon))
          );
        } else {
          return (
            (source.item.slot !== targetSlot || source.inventory !== inventoryType) &&
            inventoryType !== InventoryType.SHOP &&
            inventoryType !== InventoryType.CRAFTING &&
            !(isBlacklisted && inventoryType === 'backpack')
          );
        }
      },
    }),
    [inventoryType, item]
  );
  useNuiEvent('refreshSlots', (data: { items?: ItemsPayload | ItemsPayload[] }) => {
    if (!isDragging && !data.items) return;
    if (!Array.isArray(data.items)) return;

    const itemSlot = data.items.find(
      (dataItem) => dataItem.item.slot === item.slot && dataItem.inventory === inventoryId
    );

    if (!itemSlot) return;

    manager.dispatch({ type: 'dnd-core/END_DRAG' });
  });

  const connectRef = (element: HTMLDivElement) => drag(drop(element));

  const handleContext = (event: React.MouseEvent<HTMLDivElement>) => {
    event.preventDefault();
    if (inventoryType !== 'player' || !isSlotWithItem(item)) return;

    dispatch(openContextMenu({ item, coords: { x: event.clientX, y: event.clientY } }));
  };

  const handleClick = (event: React.MouseEvent<HTMLDivElement>) => {
    dispatch(closeTooltip());
    if (timerRef.current) clearTimeout(timerRef.current);
    if (event.ctrlKey && isSlotWithItem(item) && inventoryType !== 'shop' && inventoryType !== 'crafting') {
      onDrop({ item: item, inventory: inventoryType });
    } else if (event.altKey && isSlotWithItem(item) && inventoryType === 'player') {
      onUse(item);
    }
  };

  const refs = useMergeRefs([connectRef, ref]);

  return (
    <div
      ref={refs}
      onContextMenu={handleContext}
      onClick={handleClick}
      className={`
        size-full 
        ${isDragging ? 'dragging' : ''} 
        ${isFading ? 'fade-out' : ''}
        ${item.metadata?.rarity === 'uncommon' ? 'uncommon' : item.metadata?.rarity === 'rare' ? 'rare' : item.metadata?.rarity === 'legendary' ? 'legendary' : item.metadata?.rarity === 'epic' ? 'epic' : item.metadata?.rarity === 'unique' ? 'unique' : 'common'}
      `}
      style={{
        filter:
          !canPurchaseItem(item, { type: inventoryType, groups: inventoryGroups }) || !canCraftItem(item, inventoryType)
            ? 'brightness(80%) grayscale(100%)'
            : undefined,
        // opacity: isDragging ? 0.4 : 1.0,
        backgroundColor: '#00000091', backgroundImage: inventoryType !== 'crafting' ? `url(${item?.name ? getItemUrl(item as SlotWithItem) : 'none'})` : undefined,
      }}
    >
      {isSlotWithItem(item) ? (
        inventoryType !== 'crafting' ? (
          <>
            <div
              className="item-slot-wrapper"
              onMouseEnter={() => {
                timerRef.current = window.setTimeout(() => {
                  dispatch(openTooltip({ item, inventoryType }));
                }, 500) as unknown as number;
              }}
              onMouseLeave={() => {
                dispatch(closeTooltip());
                if (timerRef.current) {
                  clearTimeout(timerRef.current);
                  timerRef.current = null;
                }
              }}
            >
              <div
                className={
                  inventoryType === 'player' && item.slot <= 5 ? 'item-hotslot-header-wrapper' : 'item-slot-header-wrapper'
                }
              >
                {/* {inventoryType === 'player' && item.slot <= 5 && <div className="inventory-slot-number">{item.slot}</div>} */}
                {item.slot < 5 || item.slot > 9 ? (
                  <div className="item-slot-info-wrapper w-full flex flex-row justify-between items-center p-2 py-1 text-[10px]">
                    <p>{item.count ? item.count.toLocaleString('en-us') + `x` : ''}</p>
                    {item.metadata?.rarity ? (
                      <p className={`text-xs font-semibold uppercase ${getRarityClass(item.metadata.rarity)}`}>{item.metadata?.rarity}</p>
                    ) : (
                      <p className='text-xs font-semibold uppercase'>common</p>
                    )}
                  </div>
                ) : (
                  inventoryType !== 'player' ? (
                    <div className="item-slot-info-wrapper w-full flex flex-row justify-between items-center p-2 py-1 text-[10px]">
                      <p>{item.count ? item.count.toLocaleString('en-us') + `x` : ''}</p>
                      {item.metadata?.rarity ? (
                        <p className={`text-xs font-semibold uppercase ${getRarityClass(item.metadata.rarity)}`}>{item.metadata?.rarity}</p>
                      ) : (
                        <p className='text-xs font-semibold uppercase'>common</p>
                      )}
                    </div>
                  ) : (
                    <div className="item-slot-info-wrapper w-full flex flex-row justify-between items-center pr-2 text-[10px] h-auto">
                      <div className='flex items-center justify-center px-1.5 h-5 mt-0.5 bg-white/60 rounded-br-md ml-0.5'>
                        <p className='text-black'>{item.slot - 4}</p>
                      </div>
                      {item.metadata?.rarity ? (
                        <p className={`text-xs font-semibold uppercase ${getRarityClass(item.metadata.rarity)}`}>{item.metadata?.rarity}</p>
                      ) : (
                        <p className='text-xs font-semibold uppercase'>common</p>
                      )}
                    </div>
                  )
                )}
              </div>
              <div className='relative'>
                <div className="w-full flex flex-row justify-between">
                  <div className="inventory-slot-label-text max-w-[70%] h-aut ">
                    {item.metadata?.label ? item.metadata.label : Items[item.name]?.label || item.name}
                  </div>
                  <div
                    className="justify-end items-end flex max-w-[30%] h-auto pr-[5px] pb-[3px] text-[13px]"
                  >
                    {/* {inventoryType === 'player' && item.slot <= 5 && <div className="inventory-slot-number">{item.slot}</div>} */}
                    {inventoryType === 'shop' && item?.price !== undefined ? (
                      <>
                        {item?.currency !== 'money' && item.currency !== 'black_money' && item.price > 0 && item.currency ? (
                          <div className="item-slot-currency-wrapper">
                            <img
                              src={item.currency ? getItemUrl(item.currency) : 'none'}
                              alt="item-image"
                              style={{
                                imageRendering: '-webkit-optimize-contrast',
                                height: 'auto',
                                width: '2vh',
                                backfaceVisibility: 'hidden',
                                transform: 'translateZ(0)',
                              }}
                            />
                            <p>{item.price.toLocaleString('en-us')}</p>
                          </div>
                        ) : (
                          <>
                            {item.price > 0 && (
                              <div
                                className="item-slot-price-wrapper"
                                style={{ color: getCurrencyColor(item.currency) }}
                              >
                                <p>
                                  {Locale.$ || '$'}
                                  {item.price.toLocaleString('en-us')}
                                </p>
                              </div>
                            )}
                          </>
                        )}
                      </>
                    ) : (
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
                    )}
                  </div>
                </div>
                <div className="absolute bottom-0 left-0 right-0">
                  {inventoryType !== 'shop' && item?.durability !== undefined && (
                    <WeightBar percent={item.durability} durability />
                  )}
                </div>
              </div>
            </div>
          </>
        ) : (
          <div className='size-full flex flex-col items-start justify-start px-3 py-3'>
            <div className='flex flex-row w-full justify-start items-end gap-2'>
              <img src={getItemUrl(item.name)} alt={item.name} className='w-12 h-12 object-contain' />
              <div className='flex flex-col items-start justify-center w-full'>
                <p className='text-md font-semibold truncate max-w-full text-white'>{Items[item.name]?.label || item.name}</p>
                <div className="tooltip-crafting-duration">
                  <ClockIcon />
                  <p>{(item.duration !== undefined ? item.duration : 3000) / 1000}s</p>
                </div>
              </div>
            </div>
            <p className='text-sm font-normal uppercase text-white truncate max-w-full mt-4'>ingredients</p>
            <div className='flex flex-col items-start justify-start w-full gap-2 overflow-y-auto max-h-32 min-h-32 kasimatiscroll mt-2'>
              {ingredients &&
                ingredients.map((ingredient) => {
                  const [item, count] = [ingredient[0], ingredient[1] as number];
                  return (
                    <div className="tooltip-ingredient" key={`ingredient-${item}`}>
                      <img src={item ? getItemUrl(item) : 'none'} alt="item-image" />
                      <p className='text-xs font-normal text-white'>
                        {count >= 1
                          ? `${count}x ${Items[item]?.label || item}`
                          : count === 0
                            ? `${Items[item]?.label || item}`
                            : count < 1 && `${count * 100}% ${Items[item]?.label || item}`}
                      </p>
                    </div>
                  );
                })}
            </div>

          </div>
        )
      ) : (
        inventoryType === 'player' && (
          item.slot === 1 ? (
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                backgroundColor: '#00000091',
                width: '100%',
                height: '100%',
              }}
            >
              <img
                src={getItemUrl('backpacks')}
                alt="Backpacks"
                style={{
                  width: '8vh',
                  height: '8vh',
                  objectFit: 'contain',
                }}
              />
            </div>
          ) : item.slot === 2 ? (
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                width: '100%',
                height: '100%',
              }}
            >
              <img
                src={getItemUrl('vest')}
                alt="Kevlar"
                style={{
                  width: '8vh',
                  height: '8vh',
                  objectFit: 'contain',
                }}
              />
            </div>
          ) : item.slot === 3 ? (
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                width: '100%',
                height: '100%',
              }}
            >
              <img
                src={getItemUrl('phones')}
                alt="Phones"
                style={{
                  width: '8vh',
                  height: '8vh',
                  objectFit: 'contain',
                }}
              />
            </div>
          ) : item.slot === 4 ? (
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                width: '100%',
                height: '100%',
              }}
            >
              <TbParachute
                style={{
                  color: 'rgba(255,255,255,0.2)',
                  width: '8vh',
                  height: '8vh',
                }}
              />
            </div>
          ) : item.slot === 5 ? (
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                width: '100%',
                height: '100%',
              }}
            >
              <img
                src={getItemUrl('rifle')}
                alt="Rifle"
                style={{
                  width: '8vh',
                  height: '8vh',
                  objectFit: 'contain',
                }}
              />
            </div>
          ) : item.slot === 6 ? (
            <div
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                width: '100%',
                height: '100%',
              }}
            >
              <img
                src={getItemUrl('pistols')}
                alt="Pistols"
                style={{
                  width: '8vh',
                  height: '8vh',
                  objectFit: 'contain',
                }}
              />
            </div>
          ) : null
        )

      )}
    </div>
  );
};

export default React.memo(React.forwardRef(InventorySlot));
