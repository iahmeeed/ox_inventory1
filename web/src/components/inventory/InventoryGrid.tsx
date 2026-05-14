// Made by Karma Developments with Love <3 

import React, { useEffect, useMemo, useRef, useState } from 'react';
import { Inventory } from '../../typings';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import { getTotalWeight } from '../../helpers';
import { useAppSelector } from '../../store';
import { useIntersection } from '../../hooks/useIntersection';
import { getItemUrl } from '../../helpers';
import CraftingSlot from './CraftingTable';
import CraftingInfo from './CraftingInformation';


import { LuWeight } from "react-icons/lu";
import { FaChevronUp } from "react-icons/fa";

interface GenderProps {
  gender: string;
}

const PAGE_SIZE = 30;
const InventoryGrid: React.FC<{ inventory: Inventory, utility?: boolean }> = ({ inventory, utility }) => {
  const weight = useMemo(
    () => (inventory.maxWeight !== undefined ? Math.floor(getTotalWeight(inventory.items) * 1000) / 1000 : 0),
    [inventory.maxWeight, inventory.items]
  );
  const [page, setPage] = useState(0);
  const containerRef = useRef(null);
  const { ref, entry } = useIntersection({ threshold: 0.5 });
  const isBusy = useAppSelector((state) => state.inventory.isBusy);
  const gender = useAppSelector((state) => state.settings.data) as GenderProps;
  const [extend, setExtend] = useState<{ [key: string]: boolean }>({});
  const [animate, setAnimate] = useState(false); // State untuk animasi
  const [search, setSearch] = useState('');
  const [filteredItems, setFilteredItems] = useState(inventory.type === 'crafting' ? inventory.items : []);

  useEffect(() => {
    if (entry && entry.isIntersecting) {
      setPage((prev) => ++prev);
    }
  }, [entry]);
  useEffect(() => {
    setExtend((prev) => ({ ...prev, [inventory.id]: true }));
  }, [inventory]);
  useEffect(() => {
    if (utility) {
      setAnimate(true);
    }
  }, [utility]);

  useEffect(() => {
    if (search.length > 0) {
      setFilteredItems(inventory.items.filter((item: any) => {
        if (item.label) {
          return item.label.toLowerCase().includes(search.toLowerCase());
        } else if (item.name) {
          return item.name.toLowerCase().includes(search.toLowerCase());
        }
        // item.label && item.label.toLowerCase().includes(search.toLowerCase())
      }));
    } else {
      setFilteredItems(inventory.items);
    }
  }, [search, inventory.items]);
  return (
    <>
      {!utility ? (
        <div className="inventory-grid-wrapper transform py-5 px-6 bg-black/25 rounded-[8px] miring transition-all duration-500 ease-in-out h-auto" style={{ background: '#00000091', pointerEvents: isBusy ? 'none' : 'auto', transform: inventory.type === 'player' && !utility || inventory.type === 'backpack' ? 'rotateX(0deg) rotateY(7deg)' : 'rotateX(0deg) rotateY(-7deg)' }}>
          <div>
            <div className="inventory-grid-header-wrapper">
              <div className='flex items-center justify-start gap-5'>
                <p className="text-xl font-semibold text-berjarak">
                  {inventory.type === 'player' ? 'Pockets' : inventory.type === 'backpack' ? 'Backpack' : inventory.type === 'crafting' ? 'RECIPES' : inventory.label}
                </p>
                {inventory.type != 'shop' && inventory.type != 'crafting' && (
                  <div className="flex items-center gap-2">
                    <LuWeight className="text-xl text-white" />
                    {inventory.maxWeight && (
                      <p className="text-[12px] font-semibold text-white">{weight / 1000} / {inventory.maxWeight / 1000} kg</p>
                    )}
                  </div>
                )}
              </div>
              {inventory.type != 'shop' && inventory.type != 'crafting' && (
                <button
                  className="flex items-center text-md font-semibold text-white transition-transform duration-200"
                  onClick={() => setExtend((prev) => ({ ...prev, [inventory.id]: !prev[inventory.id] }))}>
                  <FaChevronUp
                  // className={`transform ${extend[inventory.id] ? 'rotate-180' : 'rotate-0'} transition-transform duration-200`} 
                  // TEST NEW STUFF
                  />
                </button>

              )}
            </div>
            <div style={{ height: "10px" }}></div>
            {inventory.type != 'shop' && inventory.type != 'crafting' && (
              <WeightBar percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0} />
            )}
            {inventory.type === 'crafting' && (
              <div className='flex flex-row gap-4 justify-start items-center h-8 mt-1'>
                <div className='w-[100%] h-full flex flex-row gap-4 justify-start items-center'>
                  <input type='text' className='w-full h-full bg-black/45 text-white text-xs font-semibold border border-white/20 rounded-sm px-2 py-1' placeholder='Search' onChange={(e) => setSearch(e.target.value)} />
                </div>
              </div>
            )}
          </div>
          <div
            className={`inventory-grid-container transition-all duration-500 ease-in-out overflow-hidden ${extend[inventory.id] ? 'max-h-[1500px] opacity-100' : 'max-h-0 opacity-0'
              }`}
            style={{
              height:
                // Encontre os IDs corretos para player e backpack
                extend['player-inventory-id'] && extend['backpack-inventory-id'] && inventory.type === 'player'
                  ? 'calc(32.11vh + 30px)'
                  : extend['player-inventory-id'] && extend['backpack-inventory-id'] && inventory.type === 'backpack'
                    ? 'calc(2 * 10.77vh + 1 * 10px - 5vh)'
                    // Lógica original
                    : inventory.type === 'player'
                      ? 'calc(37.11vh + 22px)'
                      : inventory.type === 'backpack'
                        ? 'calc(2 * 10.77vh + 1 * 10px)'
                        : inventory.type === 'shop'
                          ? 'calc(34.11vh + 20px)'
                          : inventory.type === 'crafting'
                            ? 'calc(2 * 10.77vh + 1 * 10px)'
                            : 'calc(4 * 10.77vh + 3 * 10px)',
            }}
            ref={containerRef}
          >


            <>
              {inventory.type === 'player' ? (
                inventory.items.slice(11, (page + 1) * PAGE_SIZE).map((item, index) => (
                  <InventorySlot
                    key={`${inventory.type}-${inventory.id}-${item.slot}`}
                    item={item}
                    ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                    inventoryType={inventory.type}
                    inventoryGroups={inventory.groups}
                    inventoryId={inventory.id}
                  />
                ))
              ) : inventory.type === 'crafting' ? (
                filteredItems.slice(0, (page + 1) * PAGE_SIZE).map((item, index) => (
                  <CraftingSlot
                    key={`${inventory.type}-${inventory.id}-${item.slot}`}
                    item={item}
                    // ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                    inventoryType={inventory.type}
                    inventoryGroups={inventory.groups}
                    inventoryId={inventory.id}
                  />
                ))
              ) : (
                inventory.items.slice(0, (page + 1) * PAGE_SIZE).map((item, index) => (
                  <InventorySlot
                    key={`${inventory.type}-${inventory.id}-${item.slot}`}
                    item={item}
                    ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                    inventoryType={inventory.type}
                    inventoryGroups={inventory.groups}
                    inventoryId={inventory.id}
                  />
                ))
              )}
            </>
          </div>
          {inventory.type === 'crafting' && (
            <CraftingInfo />
          )}
        </div>
      ) : (
        <div
          className={`inventory-grid-wrapper transform py-5 px-6 transition-all duration-500 ease-in-out h-auto gap-5 border-none items-center ${animate ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-10'
            }`}
          style={{
            pointerEvents: isBusy ? 'none' : 'auto',
            transform: 'rotateX(0deg) rotateY(-7deg)',
            marginTop: '4vh',
          }}
        >
          <div id='atas' className='w-auto flex flex-row gapsexy justify-start items-start relative'>
            {/* Left Column - Backpack, Body Armor, Phone */}
            <div className='utility-slot-grid'>
              {inventory.items.slice(0, 3).map((item, index) => (
                <div className='flex flex-col justify-start items-start gap-2' key={index}>
                  <p className='text-sm font-semibold uppercase whitespace-nowrap'>{index === 0 ? 'backpack' : index === 1 ? 'body armour' : 'phone'}</p>
                  <div className='utility-slot-box'>
                    <InventorySlot
                      key={`${inventory.type}-${inventory.id}-${item.slot}`}
                      item={item}
                      ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                      inventoryType={inventory.type}
                      inventoryGroups={inventory.groups}
                      inventoryId={inventory.id}
                    />
                  </div>
                </div>
              ))}
            </div>

            {/* Character Image */}
            <div className="character-image-wrapper">
              <img src={getItemUrl(gender.gender)} alt="character"
                style={{
                  height: '50vh',
                  width: 'auto',
                }}
                className="img-rendering" />
            </div>

            {/* Right Column - Parachute, Weapon Slots */}
            <div className='utility-slot-grid'>
              {inventory.items.slice(3, 6).map((item, index) => (
                <div className='flex flex-col justify-start items-start gap-2' key={index}>
                  <p className='text-sm font-semibold uppercase whitespace-nowrap'>{index === 0 ? 'parachute' : 'weapon slot'}</p>
                  <div className='utility-slot-box'>
                    <InventorySlot
                      key={`${inventory.type}-${inventory.id}-${item.slot}`}
                      item={item}
                      ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                      inventoryType={inventory.type}
                      inventoryGroups={inventory.groups}
                      inventoryId={inventory.id}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Hotkey Slots - 5 slots in a row */}
          <div className="hotkey-slot-grid mt-4">
            {inventory.items.slice(6, 11).map((item, index) => (
              <div className="flex flex-col justify-start items-start gap-2" key={index}>
                <p className="text-sm font-semibold uppercase whitespace-nowrap">
                  {'hotkey ' + (index + 1)}
                </p>
                <div className='utility-slot-box'>
                  <InventorySlot
                    item={item}
                    ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                    inventoryType={inventory.type}
                    inventoryGroups={inventory.groups}
                    inventoryId={inventory.id}
                  />
                </div>
              </div>
            ))}
          </div>

        </div>
      )}
    </>
  );
};

export default InventoryGrid;
