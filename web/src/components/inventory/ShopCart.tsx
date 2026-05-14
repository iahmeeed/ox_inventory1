// Made by Karma Developments with Love <3 


import React, { useEffect, useState } from 'react';
import { useDrop } from 'react-dnd';
import { Inventory, DragSource } from '../../typings';
import { Locale } from '../../store/locale';
import { getItemUrl } from '../../helpers';
import { useAppSelector } from '../../store';
import { RiAddBoxLine } from "react-icons/ri";
import { FaMinus, FaPlus, FaRegTrashCan } from "react-icons/fa6";
import { GiTwoCoins } from "react-icons/gi";
import { FaCcMastercard } from "react-icons/fa";
import { onBuy } from '../../dnd/onBuy';
import { SlotWithItem } from '../../typings';
import { getRarityClass } from '../../utils/themeHelper';
import { Items } from '../../store/items';  // Importando Items para acessar as informações adicionais do item

const ShopCart: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const isBusy = useAppSelector((state) => state.inventory.isBusy);
  const [sourcee, setSourcee] = useState<DragSource | null>(null);
  const [cartItems, setCartItems] = useState<{
    name: string;
    quantity: number;
    price: number;
    slot: number;
    currency: string;
    metadata?: { rarity?: string; label?: string };
  }[]>([]); // Tipagem ajustada para incluir metadata

  const [onlyCash, setOnlyCash] = useState<boolean>(false);
  const [inventoryType, setInventoryType] = useState<string>('');

  const [{ isOver }, drop] = useDrop({
    accept: 'SLOT',
    drop: (source: DragSource) => {
      if (!sourcee) setSourcee(source);
      if (inventoryType === '') setInventoryType(source.inventory);

      // Verificando se o item já está no carrinho
      const existingItem = cartItems.find((item) => item.name === source.item.name);
      if (existingItem) {
        // Se o item já estiver no carrinho, incrementamos a quantidade
        setCartItems((prev) =>
          prev.map((item) =>
            item.name === source.item.name
              ? { ...item, quantity: item.quantity + 1 }
              : item
          )
        );
      } else {
        // Se não estiver no carrinho, adicionamos um novo item
        setCartItems((prev) => [
          ...prev,
          {
            name: source.item.name,
            quantity: 1,
            price: source.item.price ?? 0,
            slot: source.item.slot,
            currency: source.item.currency ?? '',
            metadata: (source.item as SlotWithItem).metadata, // Garantindo que metadata seja passada
          },
        ]);
        if (source.item.currency !== 'money') setOnlyCash(true);
      }
    },
    collect: (monitor) => ({
      isOver: monitor.isOver(),
    }),
  });

  const handlePay = (type: string) => {
    if (!sourcee) return;
    onBuy(sourcee, { inventory: inventoryType, item: { slot: cartItems[0].slot } }, cartItems[0].quantity, type, cartItems);
  };

  return (
    <>
      <div
        className="inventory-grid-wrapper w-full transform pyshopping px-6 bg-black/25 rounded-[8px] miring transition-all duration-500 ease-in-out h-auto"
        style={{
          background:'#00000091',
          pointerEvents: isBusy ? 'none' : 'auto',
          transform:
            inventory.type === 'player' || inventory.type === 'backpack' ? 'rotateX(0deg) rotateY(7deg)' : 'rotateX(0deg) rotateY(-7deg)',
        }}
      >
        <div>
          <p className="text-xl font-semibold text-berjarak">Shopping Cart</p>
          <p className="ns" style={{ height: '10px' }}></p>
          <div className="inventory-grid-header-wrapper border-b-2 border-white/20 pb-3">
            <div className="flex items-center justify-start gap-5"></div>
          </div>
          <div className="grid grid-cols-1 gap-2 dragitemsheight overflow-y-auto mt-4 no-scrollbar" ref={drop}>
            {cartItems.length > 0 ? (
              cartItems.map((item, index) => (
                <div key={index} className="flex items-center justify-start gap-3 w-full box-cart min-h-[10rem] max-h-[12rem] px-7 py-2 rounded-[8px]" style={{ height: '8rem' }}>
                  <img src={getItemUrl(item.name)} alt={item.name} className="w-[15%] h-full object-contain" />
                  <div className="flex flex-col items-start justify-center w-[35%]">
                    {/* WORKING IN PROGRESS - RARITY IN SHOPPINGS  */}

                    {/* {item.metadata?.rarity ? (
                      <p className={`text-xs font-semibold uppercase ${getRarityClass(item.metadata?.rarity)}`}>{item.metadata?.rarity}</p>
                    ) : (
                      <p className="text-xs font-semibold uppercase">common</p>
                    )} */}
                    {/* <p className="text-md font-semibold truncate max-w-full">{item.name}</p> */}
                    <p className="text-md text-white" style={{ fontSize: '1.6rem', fontWeight: 'bolder' }}>
                      {item.metadata?.label ? item.metadata.label : Items[item.name]?.label || item.name}
                    </p>
                  </div>
                  <div className="flex flex-row items-center justify-between gap-1 flex-1">
                    <button
                      className="flex items-center justify-center w-7 h-7 rounded-md text-white text-sm font-semibold border border-white/20"
                      onClick={() =>
                        setCartItems((prev) =>
                          prev.map((cartItem) =>
                            cartItem.name === item.name && cartItem.quantity > 1 ? { ...cartItem, quantity: cartItem.quantity - 1 } : cartItem
                          )
                        )
                      }
                    >
                      <FaMinus />
                    </button>
                    <input
                      type="number"
                      className="w-12 h-7 rounded-md bgnone text-white text-sm font-semibold text-center outline-none"
                      value={item.quantity}
                      onChange={(e) => {
                        const value = Math.max(1, Number(e.target.value));
                        setCartItems((prev) =>
                          prev.map((cartItem) => (cartItem.name === item.name ? { ...cartItem, quantity: value } : cartItem))
                        );
                      }}
                    />
                    <button
                      className="flex items-center justify-center w-7 h-7 rounded-md text-white text-sm font-semibold border border-white/20"
                      onClick={() =>
                        setCartItems((prev) =>
                          prev.map((cartItem) => (cartItem.name === item.name ? { ...cartItem, quantity: cartItem.quantity + 1 } : cartItem))
                        )
                      }
                    >
                      <FaPlus />
                    </button>
                  </div>
                  <p className="text-xl font-normal text-white/50 w-[18%] text-center">
                    {Locale.$ || '$'}
                    {(item.price * item.quantity).toLocaleString('en-us')}
                  </p>
                  <button
                    className="flex items-center justify-center w-7 h-7 text-white text-xl font-semibold"
                    onClick={() => setCartItems((prev) => prev.filter((cartItem) => cartItem.name !== item.name))}
                  >
                    <FaRegTrashCan />
                  </button>
                </div>
              ))
            ) : (
              <div className="flex flex-col items-center justify-center w-full bg-red-400/0 min-h-[5rem]">
                <RiAddBoxLine className="text-5xl text-white/40" />
                <p className="text-lg font-normal text-berjarak text-white/40 uppercase">drag shop items here</p>
                <p className="text-sm font-normal text-white/40 uppercase">alternatively, double click or shift + click</p>
              </div>
            )}
          </div>
          <div className="flex flex-col w-full mt-4 border-t-2 border-white/20 pt-2 transition-all duration-200">
            {cartItems.length > 0 && (
              <>
                <div className="flex items-center justify-between w-full">
                  <p className="text-xl font-normal uppercase">Total Cost</p>
                  <p className="text-xl font-semibold uppercase text-white" style={{ fontSize: '1.5rem' }}>
                    {Locale.$ || '$'}
                    {cartItems.reduce((acc, item) => acc + item.price * item.quantity, 0).toLocaleString('en-us')}
                  </p>
                </div>
                {onlyCash && (
                  <div className="flex items-center justify-between w-full">
                    <p className="text-xl font-normal uppercase">black money Total Cost</p>
                    <p className="text-xl font-semibold uppercase text-white" style={{ fontSize: '1.5rem' }}>
                      {Locale.$ || '$'}
                      {cartItems
                        .filter((item) => item.currency !== 'money')
                        .reduce((acc, item) => acc + item.price * item.quantity, 0)
                        .toLocaleString('en-us')}
                    </p>
                  </div>
                )}
                <div className="flex items-center justify-end w-full gap-2 mt-2">
                  {!onlyCash && (
                    <button
                      className="flex flex-row gap-2 items-center justify-center w-auto px-3 h-10 rounded-sm bg-black/50 text-white text-md font-semibold border border-white/20 hover:bg-primary/15 hover:border-primary/30 transition-all duration-200"
                      onClick={() => handlePay('bank')}
                    >
                      <FaCcMastercard className="text-xl" />
                      <p>Pay Bank</p>
                    </button>
                  )}
                  <button
                    className="flex flex-row gap-2 items-center justify-center w-auto px-3 h-10 rounded-sm bg-black/50 text-white text-md font-semibold border border-white/20 hover:bg-primary/15 hover:border-primary/40 transition-all duration-200"
                    onClick={() => handlePay('cash')}
                  >
                    <GiTwoCoins className="text-xl" />
                    <p>Pay Cash</p>
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      </div>
    </>
  );
};

export default ShopCart;
