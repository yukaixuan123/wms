using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;

namespace WMS.Domain.Repository.Cm
{
    public interface IBs_itemRepository
    {
        //查询全部货品信息
        Task<List<Bs_item>> ItemSelectAsync();
        //货品信息逻辑删除
        Task<bool> ItemDeleteAsync(int id,string bl);
        //添加货品信息
        Task<bool> ItemAddAsync(Bs_item Bs_Item);
        //修改货品信息
        Task<bool> ItemUpdateAsync(Bs_item Bs_Item);
        //货品信息分页查询
        FenYe<Bs_item> ItemFenYeAsync(int page, int pageSize, string bh,string zt,string lx,string dw);
        //货品类型下拉框
        Task<IEnumerable<Bs_item_type>> BsItemTypesAsync();
        //货品信息批量删除
        Task<bool> PLDeleteItem(int[] num);


        //查询货品信息
        Task<FenYeUsers<GoodsInfo>> FindGoodsInfo(int PageSize, int CurrentPage, string str);

        //新增货品信息
        Task<bool> AddGoodsInfo(string item_name, string item_code, string item_type, string model_code, Decimal inbill_price, Decimal outbill_price, int sort_code, string inbill_state, string create_by, string remark, string unit, string item_type_code, string ImgUrl);

        Task<Bs_item_type> FindGoodsInfoById(string id);

        Task<GoodsInfo> FindGoodsIfoByItem_Id(int id);

        Task<bool> UpdateGoodsInFO(string item_name, string item_code, string item_type, string model_code, Decimal inbill_price, Decimal outbill_price, int sort_code, string inbill_state, string create_by, string remark, string unit, string item_type_code, int item_type_id,string ImgUrl);


        //public string[] FindGoodsIfoByItem_Id1(int id);


        Task<IEnumerable<PurchaseRecord>> FindPurchaseRecord(string item_code);

        Task<IEnumerable<Inventory>> FindWh_now_storage(string item_code);

        Task<FenYeUsers<XiaoshouJL>> FindXiaoshouJl(int PageSize, int CurrentPage, string str);

        Task<FenYeUsers<InventoryRecords>> FindInventoryRecords(int PageSize, int CurrentPage, string str);

        Task<FenYeUsers<TransferRecords>> FindTransferRecords(int PageSize, int CurrentPage, string str);

        Task<FenYeUsers<RkST>> FindRkst(int PageSize, int CurrentPage, string str);

        //查询出库记录
        Task<FenYeUsers<CkST>> FindCkSt(int PageSize, int CurrentPage, string str);
    }
}
