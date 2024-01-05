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
    public interface IWh_sale_return_hAppService
    {
        Task<IEnumerable<ST1>> Wh_sale_return_h__sr213lAsyunc(string inbill_bh);
        Task<bool> Wh_sale_return_h_sale_inserAsync(List<Wh_saleReturn_dXX> dd, Wh_inbill_h h);

        Task<IEnumerable<Wh_saleReturn_dXX>> Wh_sale_return_h__srlAsyunc(string sr_code);
        /// <summary>
        /// 销售退货添加
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_return_h_InsertAsync(List<Wh_sale_return_d> dd, Wh_sale_return_h h);
        /// <summary>
        /// 销售退货修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_return_h_UpdateAsync(List<Wh_sale_return_d> dd, Wh_sale_return_h h);
        /// <summary>
        /// 销售退货查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        Task<FenYeDapper<View_sale_return_h>> Wh_sale_return_h_FenYeAsync(int pageSize, int currentPage, string str);
        /// <summary>
        /// 退货单号查基本信息
        /// </summary>
        /// <param name="sr_code"></param>
        /// <returns></returns>
        Task<View_sale_return_h> Wh_sale_return_h_CodeAsyunc(string sr_code);
        /// <summary>
        /// 退货单号查详细信息
        /// </summary>
        /// <param name="sr_code"></param>
        /// <returns></returns>
        Task<IEnumerable<Wh_sale_return_d>> Wh_sale_return_h_Code1Asyunc(string sr_code);
        /// <summary>
        /// 根据销售订单查退货记录
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        Task<IEnumerable<Wh_sale_return_h>> Wh_sale_return_h__thjlAsyunc(string sale_code);

        /// <summary>
        /// 销售退货删除
        /// </summary>
        /// <param name="sr_codeId"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_return_h_DeleteAsync(int sr_codeId);
        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_return_h_DeleteArryAsync(int[] carModel);
        /// <summary>
        /// 审核
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_return_h_sale_stateAsync(List<Wh_sale_d> dd, Wh_sale_return_h h);
        Task<bool> Wh_sale_return_h_sale_state1Async(string sale_state, string sure_man, string sale_yj, string sr_codeId);
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="sr_codeId"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_return_h_chexiaoAsync(string sure_man, int sr_codeId);
    }
}
