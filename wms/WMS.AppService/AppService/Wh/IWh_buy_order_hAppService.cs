using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.Wh;

namespace WMS.AppService.AppService.Wh
{
    public interface IWh_buy_order_hAppService
    {
        /// <summary>
        /// 审核
        /// </summary>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_buy_order_h_sale_stateAsync(string sale_state, string sure_man, int buy_codeId, string sale_state_yj);
        Task<bool> Wh_buy_order_h_chexiaoAsync(string sure_man, int buy_codeId);

        Task<Users> UsersID(string username, string password);

        Task<IEnumerable<Wh_orderbuy_d>> Wh_buy_order_h_Code1Asyunc(string buy_code);
        Task<IEnumerable<ST1>> Wh_buy_order_h_Code2Asyunc(string buy_code);
        /// <summary>
        /// 根据单号查进货订单
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        Task<View_Order> Wh_buy_order_h_CodeAsyunc(string buy_code);
        /// <summary>
        /// 进货订单批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        Task<bool> Wh_buy_order_h_DeleteArryAsync(int[] carModel);
        /// <summary>
        /// 进货订单删除
        /// </summary>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        Task<bool> Wh_buy_order_h_DeleteAsync(int buy_codeId);
        /// <summary>
        /// 进货订单添加
        /// </summary>
        /// <param name="sg"></param>
        /// <param name="gg"></param>
        /// <returns></returns>
        Task<bool> Wh_buy_order_h_InsertAsync(List<Wh_orderbuy_d> dd, Wh_buy_order_h h);
        /// <summary>
        /// 进货订单修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_buy_order_h_UpdateAsync(List<Wh_orderbuy_d> dd, Wh_buy_order_h h);
        /// <summary>
        /// 进货订单查询
        /// </summary>
        /// <param name="fenYe"></param>
        /// <returns></returns>
        Task<FenYeDapper<View_Order>> Wh_buy_order_hFenYeAsync(int pageSize,int currentPage, string str);

        /// <summary>
        /// 货品信息查询
        /// </summary>
        /// <param name="fenYe"></param>
        /// <returns></returns>
        Task<FenYeDapper<View_Bs_Item>> Bs_item_FenYeAsync(int pageSize, int currentPage, string str);

        /// <summary>
        /// 用户信息
        /// </summary>
        /// <returns></returns>
        Task<List<Users>> UserFind();
        /// <summary>
        /// 供应商
        /// </summary>
        /// <returns></returns>
        Task<List<Bs_supply>> SuplyFind();
        /// <summary>
        /// 根据名字查供应商
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        Task<Bs_supply> SuplyFindName(string name);
    }
}
