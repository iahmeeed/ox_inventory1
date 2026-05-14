// Made by Karma Developments with Love <3 

import InventoryComponent from './components/inventory';
import useNuiEvent from './hooks/useNuiEvent';
import { Items } from './store/items';
import { Locale } from './store/locale';
import { setImagePath } from './store/imagepath';
import { setupInventory } from './store/inventory';
import { Inventory } from './typings';
import { useAppDispatch } from './store';
import { debugData } from './utils/debugData';
import DragPreview from './components/utils/DragPreview';
import { fetchNui } from './utils/fetchNui';
import { useDragDropManager } from 'react-dnd';
import { updatePlayerList } from './store/playerlist';
import { updateSettings } from './store/settings';
import KeyPress from './components/utils/KeyPress';
import { applyTheme, UITheme } from './utils/theme';

debugData([
  {
    action: 'setupInventory',   
    data: {
      leftInventory: {
        id: 'test', 
        type: 'player',
        slots: 50,
        label: 'Bob Smith',
        weight: 3000,
        maxWeight: 5000,
        items: [
          { 
            slot: 1,
            name: 'iron',
            weight: 3000,
            rarity: 'rare',
            metadata: {
              description: `name: Svetozar Miletic  \n Gender: Male`,
              ammo: 3,
              mustard: '60%',
              ketchup: '30%',
              mayo: '10%',
            },
            count: 5,
          },
          { slot: 2, name: 'powersaw', weight: 0, count: 1, metadata: { durability: 75 } },
          { slot: 3, name: 'copper', weight: 100, count: 12, metadata: { type: 'Special' } },
          {
            slot: 10,
            name: 'water',
            type: 'weapon',
            weight: 100,
            rarity: 'uncommon',
            count: 10,
            metadata: { description: 'Generic item description' },
          },
          { slot: 5, name: 'water', weight: 100, count: 1, rarity: 'epic' },
          {
            slot: 6,
            name: 'backwoods',
            weight: 100,
            count: 1,
            metadata: {
              label: 'Russian Cream',
              imageurl: 'https://i.imgur.com/2xHhTTz.png',
            },
          },
        ],
      },
      rightInventory: {
        id: 'stash',
        type: 'stash',
        slots: 16,
        label: 'Bob Smith',
        weight: 3000,
        maxWeight: 5000,
        items: [
          {
            slot: 1,
            name: 'water',
            weight: 500,
            price: 300,
            ingredients: {
              water: 1,
              // copper: 12,
              // powersaw: 0.1,
              // iron: 5,
              // www: 1,
              // ppp: 1,
              // ooo: 1,
              // iii: 1,
              // uuu: 1,
              // yyy: 1,
              // ttt: 1,
              // rrr: 1,
              // eee: 1,
              // qqq: 1,
            },
            duration: 3000,
            metadata: {
              description: 'Simple lockpick that breaks easily and can pick basic door locks',
            },
          },
          {
            slot: 2,
            name: 'burger',
            weight: 500,
            price: 300,
            ingredients: {
              iron: 5,
              copper: 12,
              powersaw: 0.1,
            },
            duration: 3000,
            metadata: {
              description: 'Simple lockpick that breaks easily and can pick basic door locks',
            },
          },
          // {
          //   slot: 3,
          //   name: 'burger',
          //   weight: 500,
          //   price: 300,
          //   ingredients: {
          //     iron: 5,
          //     copper: 12,
          //     powersaw: 0.1,
          //   },
          //   duration: 3000,
          //   metadata: {
          //     description: 'Simple lockpick that breaks easily and can pick basic door locks',
          //   },
          // },
        ],
      },
      leftInventoryBottom: {
        id: 'backpack',
        type: 'backpack',
        slots: 50,
        label: 'Backpack',
        weight: 3000,
        maxWeight: 5000,
        open: true,
        items: [
          {
            slot: 11,
            name: 'iron',
            weight: 1,
            metadata: {
              label: 'Iron',
              description: `name: Svetozar Miletic  \n Gender: Male`,
              ammo: 3,
              mustard: '60%',
              ketchup: '30%',
              mayo: '10%',
            },
            count: 1,
          },
          { slot: 12, name: 'powersaw', weight: 3000, count: 1, metadata: { durability: 75, label:'powershow'} },
          { slot: 13, name: 'copper', weight: 100, count: 12, metadata: { type: 'Special',label:'copper' } },
          {
            slot: 14,
            name: 'water',
            weight: 100,
            count: 1,
            metadata: { description: 'Generic item description asd asdsaj kdghaskdgashgdasdhasgdkashgdashjdgashdgasgdaskdh asdasdasdasdsa', label: 'Water'},
          },
          { slot: 15, name: 'water', weight: 100, count: 1 },
          {
            slot: 16,
            name: 'backwoods',
            weight: 100,
            count: 1,
            metadata: {
              label: 'Russian Cream',
              imageurl: 'https://i.imgur.com/2xHhTTz.png',
            },
          },
        ],
      },
    },
  },
]);
debugData([
  {
    action: 'UpdatePlayerList',
    data: {
      playerlist: [255, 256],
      slot: {
        slot: 1,
        name: 'backwoods',
        weight: 100,
        count: 1,
        metadata: {
          label: 'Russian Cream',
          imageurl: 'https://i.imgur.com/2xHhTTz.png',
        },
      },
      count: 1,
    }
  }
])
debugData([
  {
    action: 'setupInventorySettings',
    data: {
      gender: 'male',
      SpecialSlot: [
        ['water'],
        ['water'],
        ['water'],
        ['water'],
      ],
      balcklistItem: ['backwoods'], 
    },
  },
]);
const App: React.FC = () => {
  const dispatch = useAppDispatch();
  const manager = useDragDropManager();

  useNuiEvent<{
    locale: { [key: string]: string };
    items: typeof Items;
    leftInventory: Inventory;
    imagepath: string;
  }>('init', ({ locale, items, leftInventory, imagepath }) => {
    for (const name in locale) Locale[name] = locale[name];
    for (const name in items) Items[name] = items[name];

    setImagePath(imagepath);
    dispatch(setupInventory({ leftInventory }));
  });
  useNuiEvent('UpdatePlayerList', (data: any) => {
    dispatch(updatePlayerList(data))
  })
  useNuiEvent('setupInventorySettings', (data: any) => {
    dispatch(updateSettings(data))
  })

  // Handle theme application from config
  useNuiEvent<UITheme>('applyTheme', (theme) => {
    // console.log('[DEBUG THEME REACT] applyTheme event received');
    // console.log('[DEBUG THEME REACT] theme data:', theme);
    if (theme && theme.enabled) {
      // console.log('[DEBUG THEME REACT] Theme is enabled, applying...');
      applyTheme(theme);
    } else {
      // console.log('[DEBUG THEME REACT] Theme is disabled or null');
    }
  });

  fetchNui('uiLoaded', {});

  useNuiEvent('closeInventory', () => {
    manager.dispatch({ type: 'dnd-core/END_DRAG' });
  });

  return (
    <div className="app-wrapper">
      <InventoryComponent />
      <DragPreview />
      <KeyPress />
    </div>
  );
};

addEventListener("dragstart", function(event) {
  event.preventDefault()
})

export default App;
