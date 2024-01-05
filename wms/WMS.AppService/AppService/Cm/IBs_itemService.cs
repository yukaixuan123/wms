using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Cm;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.UserRoleView;

namespace WMS.AppService.AppService.Cm
{
    public interface IBs_itemService
    {
        //查询全部货品信息
        Task<List<Bs_item>> ItemSelectAsync();
        //货品信息逻辑删除
        Task<bool> ItemDeleteAsync(int id,string bl);
        //添加货品信息
        Task<bool> ItemAddAsync(AddBs_itemDtos addBs_ItemDtos);
        //修改货品信息
        Task<bool> ItemUpdateAsync(UpdateBs_itemDtos updateBs_ItemDtos);
        //分页模糊查询
        FenYe<Bs_item> ItemFenYeAsync(int page, int pageSize, string bh,string zt,string lx,string dw);
        //货品类型下拉框
        Task<IEnumerable<Bs_item_type>> BsItemTypesAsync();
        //货品信息批量删除
        Task<bool> PLDeleteItem(int[] num);

        //查询货品信息
        Task<FenYeUsers<GoodsInfo>> FindGoodsInfo(int PageSize, int CurrentPage, string str);

        Task<bool> AddGoodsInfo(string item_name,string item_code,string item_type,string model_code, Decimal inbill_price,Decimal outbill_price,int sort_code,string inbill_state,string create_by,string remark, string unit,string item_type_code,string ImgUrl);


        Task<Bs_item_type> FindGoodsInfoById(string id);

        Task<GoodsInfo> FindGoodsIfoByItem_Id(int id);

        //xg
        Task<bool> UpdateGoodsInFO(string item_name, string item_code, string item_type, string model_code, Decimal inbill_price, Decimal outbill_price, int sort_code, string inbill_state, string create_by, string remark, string unit, string item_type_code,int item_type_id, string ImgUrl);


        // string[] FindGoodsIfoByItem_Id1(int id);

        //查询进货记录
        Task<IEnumerable<PurchaseRecord>> FindPurchaseRecord(string item_code);


        //查询库存记录
        Task<IEnumerable<Inventory>> FindWh_now_storage(string item_code);


        //查询销售记录
        Task<FenYeUsers<XiaoshouJL>> FindXiaoshouJl(int PageSize, int CurrentPage, string str);

        //查询盘点记录
        Task<FenYeUsers<InventoryRecords>> FindInventoryRecords(int PageSize, int CurrentPage, string str);

        Task<FenYeUsers<TransferRecords>> FindTransferRecords(int PageSize, int CurrentPage, string str);


        //查询入库记录
        Task<FenYeUsers<RkST>>FindRkst(int PageSize, int CurrentPage, string str);

        //查询出库记录
        Task<FenYeUsers<CkST>> FindCkSt(int PageSize, int CurrentPage, string str);

    }
}
