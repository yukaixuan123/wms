using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Cm;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Repository.Cm;

namespace WMS.AppService.AppService.Cm
{
    public class Bs_itemService : IBs_itemService
    {
        private readonly IBs_itemRepository bs_ItemRepository;
        private readonly IMapper mapper;
        public Bs_itemService(IBs_itemRepository bs_itemRepository, IMapper mapper)
        {
            this.bs_ItemRepository = bs_itemRepository;
            this.mapper = mapper;
        }

        public async Task<bool> AddGoodsInfo(string item_name, string item_code, string item_type, string model_code, decimal inbill_price, decimal outbill_price, int sort_code, string inbill_state, string create_by, string remark, string unit, string item_type_code, string ImgUrl)
        {
            return await bs_ItemRepository.AddGoodsInfo(item_name,item_code, item_type, model_code, inbill_price, outbill_price, sort_code, inbill_state, create_by, remark,unit,item_type_code, ImgUrl);
        }

        /// <summary>
        /// 货品类型下拉框
        /// </summary>
        /// <returns></returns>
        public Task<IEnumerable<Bs_item_type>> BsItemTypesAsync()
        {
            return bs_ItemRepository.BsItemTypesAsync();
        }

        public async Task<FenYeUsers<CkST>> FindCkSt(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemRepository.FindCkSt(PageSize, CurrentPage, str);
        }

        public async Task<GoodsInfo> FindGoodsIfoByItem_Id(int id)
        {
           return await bs_ItemRepository.FindGoodsIfoByItem_Id(id);
        }

        //public string[] FindGoodsIfoByItem_Id1(int id)
        //{
        //  return bs_ItemRepository.FindGoodsIfoByItem_Id1(id);
        //}

        public async Task<FenYeUsers<GoodsInfo>> FindGoodsInfo(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemRepository.FindGoodsInfo(PageSize,CurrentPage,str);
        }

        public async Task<Bs_item_type> FindGoodsInfoById(string id)
        {
            return await bs_ItemRepository.FindGoodsInfoById(id);
        }

        public async Task<FenYeUsers<InventoryRecords>> FindInventoryRecords(int PageSize, int CurrentPage, string str)
        {
          return await bs_ItemRepository.FindInventoryRecords(PageSize,CurrentPage,str);
        }

        public async Task<IEnumerable<PurchaseRecord>> FindPurchaseRecord(string item_code)
        {
           return await bs_ItemRepository.FindPurchaseRecord(item_code);
        }

        public async Task<FenYeUsers<RkST>> FindRkst(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemRepository.FindRkst(PageSize,CurrentPage,str);
        }

        public async Task<FenYeUsers<TransferRecords>> FindTransferRecords(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemRepository.FindTransferRecords(PageSize,CurrentPage,str);
        }

        public async Task<IEnumerable<Inventory>> FindWh_now_storage(string item_code)
        {
            return await bs_ItemRepository.FindWh_now_storage(item_code);
        }

        public async Task<FenYeUsers<XiaoshouJL>> FindXiaoshouJl(int PageSize, int CurrentPage, string str)
        {
            return await bs_ItemRepository.FindXiaoshouJl(PageSize, CurrentPage, str);
        }

        /// <summary>
        /// 货品信息分页查询
        /// </summary>
        /// <param name="page">总页数</param>
        /// <param name="pageSize">总条数</param>
        /// <param name="bh">编号</param>
        /// <param name="zt">状态</param>
        /// <param name="lx">类型</param>
        /// <param name="dw">单位</param>
        /// <returns></returns>
        public FenYe<Bs_item> ItemFenYeAsync(int page, int pageSize, string bh,string zt,string lx,string dw)
        {
            return bs_ItemRepository.ItemFenYeAsync(page, pageSize, bh,zt,lx,dw);
        }
        /// <summary>
        /// 查询全部货品信息
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_item>> ItemSelectAsync()
        {
            return bs_ItemRepository.ItemSelectAsync();
        }
        /// <summary>
        /// 货品信息批量删除
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        public Task<bool> PLDeleteItem(int[] num)
        {
            return bs_ItemRepository.PLDeleteItem(num);
        }

        public async Task<bool> UpdateGoodsInFO(string item_name, string item_code, string item_type, string model_code, decimal inbill_price, decimal outbill_price, int sort_code, string inbill_state, string create_by, string remark, string unit, string item_type_code, int item_type_id, string ImgUrl)
        {
            return await bs_ItemRepository.UpdateGoodsInFO(item_name, item_code, item_type, model_code, inbill_price, outbill_price, sort_code, inbill_state, create_by, remark, unit, item_type_code, item_type_id, ImgUrl);
        }

        /// <summary>
        /// 添加货品信息
        /// </summary>
        /// <param name="addBs_ItemDtos"></param>
        /// <returns></returns>
        Task<bool> IBs_itemService.ItemAddAsync(AddBs_itemDtos addBs_ItemDtos)
        {
            Bs_item bs_Item = mapper.Map<Bs_item>(addBs_ItemDtos);
            return bs_ItemRepository.ItemAddAsync(bs_Item);
        }
        /// <summary>
        /// 货品信息逻辑删除
        /// </summary>
        /// <param name="id"></param>
        /// <param name="bl">条件</param>
        /// <returns></returns>
        Task<bool> IBs_itemService.ItemDeleteAsync(int id,string bl)
        {
            //Bs_item bs_Item = mapper.Map<Bs_item>(deleteBs_ItemDtos);
            return bs_ItemRepository.ItemDeleteAsync(id, bl);
        }
        /// <summary>
        /// 修改货品信息
        /// </summary>
        /// <param name="updateBs_ItemDtos"></param>
        /// <returns></returns>
        Task<bool> IBs_itemService.ItemUpdateAsync(UpdateBs_itemDtos updateBs_ItemDtos)
        {
            Bs_item bs_Item = mapper.Map<Bs_item>(updateBs_ItemDtos);
            return bs_ItemRepository.ItemUpdateAsync(bs_Item);
        }

       

    }
}
