// Made by Karma Developments with Love <3 

import React, { useCallback, useRef, useState, useMemo, useEffect } from 'react';
import { DragSource, Inventory, InventoryType, Slot, SlotWithItem } from '../../typings';
import { useAppDispatch, useAppSelector } from '../../store';
import { getItemUrl } from '../../helpers';
import { Items } from '../../store/items';
import { onCraft } from '../../dnd/onCraft';
import { getRarityClass } from '../../utils/themeHelper';


interface SlotProps {
  inventoryId: Inventory['id'];
  inventoryType: Inventory['type'];
  inventoryGroups: Inventory['groups'];
  item: Slot;
}
const CraftingInfo: React.FC = () => {
    const GlobalData = useAppSelector((state:any) => state.craftItems.data);
    const MaxCraft = GlobalData.maxCraft as number;
    const craftItems = GlobalData.item as SlotWithItem;
    const source = GlobalData.source as DragSource;
    const [count, setCount] = useState(MaxCraft);
    const handleClick = () => {
        if (MaxCraft === 0) return;
        if (count <= MaxCraft) {
            onCraft(source, { inventory: 'player', item: { slot: -1 }}, count);
        }
    };
    useEffect(() => {
        setCount(MaxCraft);
    }, [MaxCraft]);
    return (
        <div className='flex flex-col items-start justify-start w-full h-auto gap-3 border-t border-white/20 pt-5'>
            {craftItems && craftItems.name ? (
                <>
                    <div className='flex flex-col items-start justify-start gap-1'>
                        <p className='text-white text-xl font-semibold' style={{lineHeight: '1vh'}}>{craftItems.metadata?.label ? craftItems.metadata.label : Items[craftItems.name]?.label || craftItems.name}</p>
                        <p className={`${getRarityClass(craftItems.metadata?.rarity) || 'text-white/50'} text-md`}>{craftItems.metadata?.rarity ? craftItems.metadata.rarity : 'common'}</p>
                    </div>
                    <div className='flex flex-row items-center justify-start gap-3'>
                        <h1 className='text-white/40 text-xl uppercase font-semibold'>crafting time:</h1>
                        <div className='px-2 bg-primary/20 flex items-center justify-center border-white/20' style={{height: '3.5rem', width: '3.5rem', border: '2px solid', borderColor: '#87DA21', borderRadius: '17%'}}>
                            <p className='text-white text-lg'>10s</p>
                        </div>
                    </div>
                    <div className='flex flex-col items-start justify-start gap-1'>
                        <p className='text-white/40 text-md font-semibold uppercase'>Items required:</p>
                        <div className='grid gap-2 overflow-y-auto no-scrollbar py-1'style={{
                                height: 'fit-content',
                                maxHeight: 'calc(2 * 5rem + 1 * 10px)',
                                gridTemplateColumns: 'repeat(5, 8.2vh)',
                                gridAutoRows: '7.2vh',
                            }}>
                            {craftItems.ingredients && Object.entries(craftItems.ingredients).map(([key, value]) => {
                                return (
                                    <div key={key} className='flex flex-col items-center justify-between gap-2 bg-black/50 border border-white/20 rounded-sm min-h-[5rem] ingredient'
                                        style={{ backgroundImage: `url(${getItemUrl(key)})` }}
                                        >
                                        <p className='text-white/50 text-sm w-full text-left px-1'>{Items[key]?.label || key}</p>
                                        <p className='text-white text-md w-full text-left px-1 pb-1'>{value}</p>
                                    </div>
                                );
                            })}
                        </div>
                    </div>
                    <div id='footer' className='w-full h-9 flex flex-row justify-end items-center gap-5'>
                        <div className='flex flex-row items-center justify-start gap-3 h-full'>
                            <button className='test border border-white/20 px-4 py-1 rounded-sm h-full hover:border-primary/60 hover:bg-primary/20' onClick={() => {
                                if (count > 1) {
                                    setCount(count - 1);
                                }
                            }}>
                                <p className='text-white text-md font-semibold'>-</p>
                            </button>
                            <input type='number' className='outline-none w-12 h-full test border border-white/20 text-white text-sm font-semibold text-center' value={count} onChange={(e) => {
                                if (parseInt(e.target.value) > MaxCraft) {
                                    setCount(MaxCraft);
                                } else if (parseInt(e.target.value) < 1) {
                                    setCount(1);
                                } else {
                                    setCount(parseInt(e.target.value))
                                }
                            }} />
                            <button className='test border border-white/20 px-4 py-1 rounded-sm h-full hover:border-primary/60 hover:bg-primary/20' onClick={() => {
                                if (count < MaxCraft) {
                                    setCount(count + 1);
                                }
                            }}>
                                <p className='text-white text-md font-semibold'>+</p>
                            </button>
                        </div>
                        <button className='bg-black/50 border border-primary/60 px-4 py-1 rounded-sm h-full hover:bg-primary/20' onClick={handleClick}>
                            <p className='text-white text-md'>Craft</p>
                        </button>
                    </div>
                    <div className='flex flex-col items-start justify-start border-t border-white/20 w-full h-auto gap-3 pt-5'></div>
                    <p className='text-white/40 text-xl font-semibold'>QUEUE</p>
                    <p className='text-white/40 text-lg font-semibold'>The queue is empty</p>
                </>
            ) : (
                <p className='text-white/40 text-xl font-semibold'>The queue is empty</p>
            )}
        </div>
    );
};


export default CraftingInfo;