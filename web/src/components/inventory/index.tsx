// Made by Karma Developments with Love <3 

import React, { useState, useEffect } from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';
import InventoryHotbar from './InventoryHotbar';
import { useAppDispatch } from '../../store';
import { refreshSlots, setAdditionalMetadata, setupInventory, selectRightInventory, selectLeftInventoryBottom } from '../../store/inventory';
import { useExitListener } from '../../hooks/useExitListener';
import type { Inventory as InventoryProps } from '../../typings';
import RightInventory from './RightInventory';
import LeftInventory from './LeftInventory';
import Utility from './Utility';
import { getBackgroundClass } from '../../utils/themeHelper';
import LeftInventoryBottom from './LeftInventoryBottom';
import Tooltip from '../utils/Tooltip';
import { kosonginPlayerlist } from "../../store/playerlist";
import { closeTooltip } from '../../store/tooltip';
import { deleteCraftItems } from '../../store/selectedCraftItems';
import InventoryContext from './InventoryContext';
import { closeContextMenu } from '../../store/contextMenu';
import Fade from '../utils/transitions/Fade';
import { IoIosHelpCircleOutline } from "react-icons/io";
import { IoSettingsOutline } from "react-icons/io5";
import UsefulControls from './UsefulControls';
import { useAppSelector } from '../../store';
import ShopCart from './ShopCart';
import GiveItemPlayerList from './GiveItemPlayerList';

const Inventory: React.FC = () => {
  const [inventoryVisible, setInventoryVisible] = useState(false);
  const dispatch = useAppDispatch();
  const [hover, setHover] = useState(false);
  const [infoVisible, setInfoVisible] = useState(false);
  const [utility, setUtility] = useState(false);
  const [lastKeyPress, setLastKeyPress] = useState<number>(0);
  const delay = 500; // delay in milliseconds
  const [settingsHover, setSettingsHover] = useState(false);
const [settingsOpen, setSettingsOpen] = useState(false);


  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      const currentTime = Date.now();
      if (currentTime - lastKeyPress < delay) return;

      if (event.key === 'Q' || event.key === 'q') {
        if (utility) setUtility(false);
      } else if (event.key === 'E' || event.key === 'e') {
        if (!utility) setUtility(true);
      }

      setLastKeyPress(currentTime);
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [utility, lastKeyPress]);

  const RightInventoryData = useAppSelector(selectRightInventory);
  const LeftBottomData = useAppSelector(selectLeftInventoryBottom);

  useNuiEvent<boolean>('setInventoryVisible', setInventoryVisible);
  useNuiEvent<false>('closeInventory', () => {
    setInventoryVisible(false);
    dispatch(closeContextMenu());
    dispatch(closeTooltip());
    dispatch(kosonginPlayerlist());
    dispatch(deleteCraftItems());
  });
  useExitListener(setInventoryVisible);

  useNuiEvent<{
    leftInventory?: InventoryProps;
    rightInventory?: InventoryProps;
  }>('setupInventory', (data) => {
    dispatch(setupInventory(data));
    !inventoryVisible && setInventoryVisible(true);
  });

  useNuiEvent('refreshSlots', (data) => dispatch(refreshSlots(data)));

  useNuiEvent('displayMetadata', (data: Array<{ metadata: string; value: string }>) => {
    dispatch(setAdditionalMetadata(data));
  });

  return (
    <>
      <Fade in={inventoryVisible}>
        <div className="inventory-wrapper relative">
          <GiveItemPlayerList />
          {RightInventoryData.type !== 'shop' && RightInventoryData.type !== 'crafting' && (
          <div id='info' className='absolute top7 right12 flex flex-row gap-3 z-10' style={{ perspective: '1000px' }}>
            <div 
              className={`border-2 py2 px10 testf rounded-sm flex gap-2 items-center justify-center transition-colors ${
                !utility 
                  ? '!bg-primary/20 !border-primary/40'  // Força os estilos com !important
                  : ''
              }`} 
              onClick={() => setUtility(false)}
            >
              <div className='test py-1 px-2 rounded-sm text-xs border border-white/20 font-semibold'>
                Q
              </div>
              <p className='text-white text-sm font-semibold uppercase'>INVENTORIES</p>
            </div>
            
            <div 
              className={`border-2 py2 px7 testf rounded-sm flex gap-2 items-center justify-center transition-colors ${
                utility 
                  ? '!bg-primary/20 !border-primary/40'  // Força os estilos com !important
                  : ''
              }`} 
              onClick={() => setUtility(true)}
            >
              <p className='text-white text-sm font-semibold uppercase'>utility</p>
              <div className='test py-1 px-2 rounded-sm text-xs border border-white/20 font-semibold'>
                E
              </div>
            </div>
          </div>
          )}
          <UsefulControls infoVisible={infoVisible} setInfoVisible={setInfoVisible} />
          <div className='h-full flex flex-col items-center justify-center gap-3 py-10' style={{ perspective: '1000px' }}>
            <LeftInventory />
            {LeftBottomData.open && (
              <LeftInventoryBottom />
            )}
          </div>
            <div className="absolute bottom-0 left-1/2 -translate-x-1/2 flex items-center gap-1">
              {/* Settings */}
              {/* <span
                className='h-16 cursor-pointer p-2 m-2 text-white/70 hover:text-primary hover:shadow-primary rounded-md flex flex-col items-center'
                onMouseEnter={() => setSettingsHover(true)}
                onMouseLeave={() => setSettingsHover(false)}
                onClick={() => setSettingsOpen(!settingsOpen)}
              >
                <IoSettingsOutline className='text-2xl hover:drop-shadow-primary' />
                {settingsHover && (
                  <p className='hover:text-shadow-primary uppercase text-[10px] font-semibold'>
                    
                  </p>
                )}
              </span> */}

              {/* Help */}
              <span
                className='h-16 cursor-pointer p-2 m-2 text-white/70 hover:text-primary hover:shadow-primary rounded-md flex flex-col items-center'
                onMouseEnter={() => setHover(true)}
                onMouseLeave={() => setHover(false)}
                onClick={() => setInfoVisible(!infoVisible)}
              >
                <IoIosHelpCircleOutline className='text-2xl hover:drop-shadow-primary' />
                {hover && (
                  <p className='hover:text-shadow-primary uppercase text-[10px] font-semibold'>
                    
                  </p>
                )}
              </span>
            </div>
            {/* <span className='absolute h-16 cursor-pointer bottom-0 left-1/2 transform -translate-x-1/2 p-2 m-2 text-white/70 hover:text-primary hover:shadow-primary rounded-md flex flex-col items-center' onMouseEnter={() => setHover(true)} onMouseLeave={() => setHover(false)} onClick={() => setInfoVisible(!infoVisible)}>
              <IoIosHelpCircleOutline className='text-2xl hover:drop-shadow-primary' />
              {hover && <p className='hover:text-shadow-primary uppercase text-[10px] font-semibold'>help & keybinds</p>}
            </span> */}
          <div className='h-full flex flex-col items-center justify-center gap-3 py-10' style={{ perspective: '1000px' }}>
            {RightInventoryData.type !== 'shop' && RightInventoryData.type !== 'crafting' ? (
              utility ? (
                <Utility />
              ) : (
                <RightInventory />
              )
            ) : (
              <RightInventory />
            )}
            {RightInventoryData.type === 'shop' && <ShopCart inventory={RightInventoryData} />}
          </div>
          <Tooltip />
          <InventoryContext />
        </div>
      </Fade>
      <InventoryHotbar />
    </>
  );
};

export default Inventory;
