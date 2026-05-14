// Made by Karma Developments with Love <3 

import React, { useState, useEffect } from 'react';
import { onDrop } from '../../dnd/onDrop';
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

interface Props {
  infoVisible: boolean;
  setInfoVisible: React.Dispatch<React.SetStateAction<boolean>>;
  item: any;
}

const SplitItem: React.FC<Props> = ({ infoVisible, setInfoVisible, item }) => {
  if (!item) return null;
  const { refs, context } = useFloating({
    open: infoVisible,
    onOpenChange: setInfoVisible,
  });

  const dismiss = useDismiss(context, { outsidePressEvent: 'mousedown' });
  const { isMounted, styles } = useTransitionStyles(context);
  const { getFloatingProps } = useInteractions([dismiss]);

  const [splitValue, setSplitValue] = useState(Math.ceil(item.count / 2));

  useEffect(() => {
    if (!infoVisible) {
      setSplitValue(Math.ceil(item.count / 2));
    }
  }, [infoVisible, item.count]);

  const handleSplit = (fraction: number) => {
    const newValue = Math.ceil(item.count / fraction);
    setSplitValue(newValue);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = parseInt(e.target.value, 10);
    if (value >= 0 && value <= item.count) {
      setSplitValue(value);
    }
  };

  if (!isMounted) {
    return null;
  }

  const HandleConfirm = () => {
    onDrop({ item: item, inventory: 'player' }, { inventory: 'player', item: { slot: -1 } }, splitValue);
    setInfoVisible(false);
  };

  return (
    <FloatingPortal>
      <FloatingOverlay
        lockScroll
        className="useful-controls-dialog-overlay flex items-center justify-center"
        data-open={infoVisible}
        style={styles}
      >
        <FloatingFocusManager context={context}>
          <div
            ref={refs.setFloating}
            {...getFloatingProps()}
            className="p-6 flex flex-col gap-4 justify-start items-center"
            style={{
              background: '#00000056',
              borderRadius: '11%',
              border: '2px solid #303030ff',
            }}
          >
            <div
              className="w-full flex items-center justify-center h-fit uppercase text-2xl font-semibold"
              style={{
                lineHeight: '2rem',
                fontSize: '29px',
                color: '#dfdfdf',
                transform: 'scaleY(1.5)',
              }}
            >
              <p>SPLIT</p>
            </div>

            <div className="flex flex-col gap-4 justify-start items-center w-auto">
              <p className="gap-4"></p>

              <p className="text-white text-m"
                style={{
                fontWeight: 500,
                color: '#ffffffff',
              }}
              >Item Quantity</p>
              
              <input
                className="w-[10rem] bg-[#0e0e0ee0] py-2 rounded-md text-white text-center font-semibold"
               style={{
              border: '2px solid #303030',
            }}
                type="number"
                value={splitValue}
                onChange={handleInputChange}
                min={0}
                max={item.count}
              />
              <input
                className="inputRange mt-3 w-[80%] bg-transparent"
                type="range"
                value={splitValue}
                onChange={(e) => setSplitValue(Number(e.target.value))}
                min={0}
                max={item.count}
                style={{
                  background: `linear-gradient(to right, #b7fa65ff ${((splitValue / item.count) * 100)}%, #5b7a19ff ${((splitValue / item.count) * 100)}%)`,
                  WebkitAppearance: 'none',  // Remove o estilo padrão do slider no Chrome
                  appearance: 'none',        // Para Firefox
                  height: '6px',             // Altura da linha do slider
                  borderRadius: '5px',       // Bordas arredondadas na linha
                  marginTop: '12px',         // Espaço acima do slider
                }}
              />
              <div className="flex gap-2 mt-4">
                <button
                  className="pxcustom py-2 bg-[#0e0e0ee0]  text-white rounded-md hover:bg-[#505050] hover:border-white/50 transition-all font-semibold"
              style={{
              border: '2px solid #303030',
            }}
                  onClick={() => handleSplit(2)}
                >
                  1/2
                </button>
                <button
                  className="pxcustom py-2 bg-[#0e0e0ee0] text-white rounded-md hover:bg-[#505050] hover:border-white/50 transition-all font-semibold"
                                style={{
              
              border: '2px solid #303030',
            }}
                  onClick={() => handleSplit(3)}
                >
                  1/3
                </button>
                <button
                  className="pxcustom py-2 bg-[#0e0e0ee0]  text-white rounded-md hover:bg-[#505050] hover:border-white/50 transition-all font-semibold"
                                style={{
              
              border: '2px solid #303030',
            }}
                  onClick={() => handleSplit(4)}
                >
                  1/4
                </button>
              </div>
              <div className="flex gap-4 mt-6 w-full justify-center">
                <button
                  onClick={() => {
                    setInfoVisible(false);
                  }}
                  className="flex-1 py-2 bg-[#0e0e0ee0]  text-white rounded-md hover:bg-[#505050] hover:border-white/50 transition-all text-sm font-semibold"
                                style={{
              
              border: '2px solid #303030',
              fontWeight: 'bolder',
            }}
                >
                  Cancel
                </button>
                <button
                  onClick={() => {
                    HandleConfirm();
                  }}
                  className="flex-1 py-2 bg-[#0e0e0ee0] text-white rounded-md hover:bg-[#505050] hover:border-white/50 transition-all text-sm font-semibold "
                                style={{
              
              border: '2px solid #303030',
              fontWeight: 'bolder',
            }}
                >
                  Split
                </button>
              </div>
            </div>
          </div>
        </FloatingFocusManager>
      </FloatingOverlay>
    </FloatingPortal>
  );
};

export default SplitItem;
