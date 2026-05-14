import { isSlotWithItem, findAvailableSlot } from '../helpers';
import { store } from '../store';
import { DragSource, DropTarget, SlotWithItem } from '../typings';
import { Items } from '../store/items';
import { buyItem } from '../thunks/buyItem';


export const onBuy = async (source: DragSource, target: DropTarget, itemCount?: number, type?: string, cartItems?: any) => {
  for (const item of cartItems) {
    const { inventory: state } = store.getState();
    
    const sourceInventory = state.rightInventory;
    const targetInventory = state.leftInventory;
    
    const sourceSlot = sourceInventory.items[item.slot - 1] as SlotWithItem;
    
    if (!isSlotWithItem(sourceSlot)) throw new Error(`ERROR onBuy: sourceSlot is not SlotWithItem`);
    
    if (sourceSlot.count === 0) continue;
    
    const sourceData = Items[sourceSlot.name];
    
    if (sourceData === undefined) {
      console.error(`Item ${sourceSlot.name} data undefined!`);
      continue;
    }
    
    const targetSlot = findAvailableSlot(sourceSlot, sourceData, targetInventory.items, 'player');
    
    if (targetSlot === undefined) {
      console.error(`Target slot undefined`);
      continue;
    }
    
    const count = itemCount || 1;
    
    const data = {
      fromSlot: sourceSlot,
      toSlot: targetSlot,
      fromType: sourceInventory.type,
      toType: targetInventory.type,
      count: count,
      type: type,
    };
    
    store.dispatch(
      buyItem({
        ...data,
        fromSlot: sourceSlot.slot,
        toSlot: targetSlot.slot,
      })
    );

    // Add a delay of 200ms
    await new Promise(resolve => setTimeout(resolve, 300));
  }
};
