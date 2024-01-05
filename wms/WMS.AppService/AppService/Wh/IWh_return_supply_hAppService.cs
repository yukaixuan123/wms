using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Wh;

namespace WMS.AppService.AppService.Wh
{
    public interface IWh_return_supply_hAppService
    {
        Task<IEnumerable<ST2>> Wh_return_supply_h_sr213lAsyunc(string outbill_bh);

        Task<bool> Wh_return_supply_h_inse123rAsync(List<Wh_GoodsReturn_dXX> dd, Wh_outbill_h h);
        Task<IEnumerable<Wh_GoodsReturn_dXX>> Wh_return_supply_h_t213Asyunc(string returns_code);
        /// <summary>
        /// 审核意见
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_return_supply_h_sale_stateAsync(List<Wh_orderbuy_d> dd, Wh_return_supply_h h);
        Task<bool> Wh_return_supply_h_sale_state1Async(string sale_state, string sure_man, string sure_yj, string buy_codeId);
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        Task<bool> Wh_return_supply_h_chexiaoAsync(string sure_man, int buy_codeId);
        /// <summary>
        /// 进货退货添加
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_return_supply_h_InsertAsync(List<Wh_return_supply_d> dd, Wh_return_supply_h h);
        /// <summary>
        /// 进货退货修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_return_supply_h_UpdateAsync(List<Wh_return_supply_d> dd, Wh_return_supply_h h);
        /// <summary>
        /// 进货退货分页查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        Task<FenYeDapper<View_Return_supply>> Wh_return_supply_hFenYeAsync(int pageSize, int currentPage, string str);
        /// <summary>
        /// 进货退货删除
        /// </summary>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        Task<bool> Wh_return_supply_h_DeleteAsync(int buy_codeId);
        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        Task<bool> Wh_return_supply_h_DeleteArryAsync(int[] carModel);
        /// <summary>
        /// 根据退货单号查基本信息
        /// </summary>
        /// <param name="returns_code"></param>
        /// <returns></returns>
        Task<View_Return_supply> Wh_return_supply_h_CodeAsyunc(string returns_code);
        /// <summary>
        /// 根据退货单号查详细信息
        /// </summary>
        /// <param name="returns_code"></param>
        /// <returns></returns>
        Task<IEnumerable<Wh_return_supply_d>> Wh_return_supply_h_Code1Asyunc(string returns_code);
        /// <summary>
        /// 根据进货订单查退货记录
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        Task<IEnumerable<Wh_return_supply_h>> Wh_return_supply_h_thjlAsyunc(string buy_code);
    }
}
