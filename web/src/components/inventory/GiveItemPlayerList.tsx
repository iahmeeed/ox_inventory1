// Made by Karma Developments with Love <3 

import React, { useState, useEffect } from 'react';
import { useAppSelector, useAppDispatch } from "../../store";
import { onDrop } from '../../dnd/onDrop';
import { kosonginPlayerlist } from "../../store/playerlist";
import { fetchNui } from '../../utils/fetchNui';
import { getBackgroundClass } from '../../utils/themeHelper';
import {
  FloatingFocusManager,
  FloatingOverlay,
  FloatingPortal,
  useDismiss,
  useFloating,
  useInteractions,
  useTransitionStyles,
} from '@floating-ui/react';

interface PlayerListData {
  playerlist: any[];
  slot: any;
  count: number;
}

const GiveItemPlayerList: React.FC = () => {
  const dispatch = useAppDispatch();
  const player = useAppSelector((state) => state.playerlist.data) as PlayerListData;
  const [selectedPlayer, setSelectedPlayer] = useState(0);
  const [count, setCount] = useState(player.count);
  const { refs, context } = useFloating({
    open: player.playerlist.length > 0,
    onOpenChange: (open: boolean) => {
      if (!open) {
        dispatch(kosonginPlayerlist());
      }
    },
  });

  const dismiss = useDismiss(context, { outsidePressEvent: 'mousedown' });
  const { isMounted, styles } = useTransitionStyles(context);
  const { getFloatingProps } = useInteractions([dismiss]);

  if (!isMounted) {
    return null;
  }

  const handleConfirm = () => {
    fetchNui('validGiveItem', { slot: player.slot, count, player: selectedPlayer });
  };

  return (
    <FloatingPortal>
      <FloatingOverlay
        lockScroll
        className="useful-controls-dialog-overlay flex items-center justify-center"
        data-open={player.playerlist.length > 0}
        style={styles}
      >
        <FloatingFocusManager context={context}>
          <div
            ref={refs.setFloating}
            {...getFloatingProps()}
            className={`${getBackgroundClass(false)} p-5 flex flex-col outline-none gap-3 rounded-xl justify-start items-center shadow-md shadow-black/70`}
          >
            <div className="w-full flex items-center justify-center h-fit uppercase text-lg font-semibold text-white">
              <p>player list</p>
            </div>
            <div className='grid grid-cols-4 gap-2 w-full overflow-y-auto h-52 kasimatiscroll'>
              {player.playerlist.map((player, index) => (
                <div key={index} className={`flex flex-row items-center justify-between w-full px-3 py-1 max-h-7 rounded-sm border hover:bg-primary/20 hover:border-primary/40 ${selectedPlayer === player ? 'bg-primary/20 border-primary/40' : 'border-white/20 bg-black/50'}`} onClick={() => setSelectedPlayer(player)}>
                  <p className='text-white/40'>{player}</p>
                </div> 
              ))}
            </div>
            <input 
              type='number' 
              className='bg-black/50 border-white/20 border py-1 px-4 rounded-sm text-white/40 hover:bg-primary/20 hover:border-primary/40 w-full outline-none text-center' 
              value={count} 
              onChange={(e) => {
              const value = parseInt(e.target.value);
              if (!isNaN(value) && value >= 1) {
                setCount(value);
              } else {
                setCount(1);
              }
              }} 
            />
            <div className='flex flex-row gap-2 w-full'>
              <button className='bg-black/50 border-white/20 border py-1 px-4 rounded-sm text-white/40 hover:bg-primary/20 hover:border-primary/40 flex-1 uppercase outline-none' onClick={() => dispatch(kosonginPlayerlist())}>
                <p>cancel</p>
              </button>
              <button className='bg-black/50 border-white/20 border py-1 px-4 rounded-sm text-white/40 hover:bg-primary/20 hover:border-primary/40 flex-1 uppercase outline-none' onClick={handleConfirm}>
                <p>give</p>
              </button>
            </div>
          </div>
        </FloatingFocusManager>
      </FloatingOverlay>
    </FloatingPortal>
  );
};

export default GiveItemPlayerList;