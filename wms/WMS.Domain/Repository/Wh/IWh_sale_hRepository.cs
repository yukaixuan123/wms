using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.Wh;

namespace WMS.Domain.Repository.Wh
{
    public interface IWh_sale_hRepository
    {
        /// <summary>
        /// 查客户信息
        /// </summary>
        /// <returns></returns>
        Task<IEnumerable<Bs_customer>> Wh_sale_hYHAsyunc();
        /// <summary>
        /// 根据客户名称查全部信息
        /// </summary>
        /// <param name="cust_name"></param>
        /// <returns></returns>
        Task<Bs_customer> Wh_sale_hNameAsyunc(string cust_name);
        /// <summary>
        /// 销售订单添加
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_h_InsertAsync(List<Wh_sale_d> dd, Wh_sale_h h);
        /// <summary>
        /// 销售订单修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_h_UpdateAsync(List<Wh_sale_d> dd, Wh_sale_h h);
        /// <summary>
        /// 销售订单查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        Task<FenYeDapper<View_Sale_h>> Wh_sale_hFenYeAsync(int pageSize, int currentPage, string str);
        /// <summary>
        /// 销售订单的删除
        /// </summary>
        /// <param name="sale_codeId"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_h_DeleteAsync(int sale_codeId);
        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_h_DeleteArryAsync(int[] carModel);

        /// <summary>
        /// 根本销售单号查销售订单
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        Task<View_Sale_h> Wh_sale_h_CodeAsyunc(string sale_code);

        /// <summary>
        /// 销售订单明细
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        Task<IEnumerable<Wh_sale_d>> Wh_sale_h_Code1Asyunc(string sale_code);
        /// <summary>
        /// 销售货品查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        Task<FenYeDapper<View_XSGoods>> Wh_sale_hGoodsFenYeAsync(int pageSize, int currentPage, string str);
        /// <summary>
        /// 销售出库
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        Task<IEnumerable<ST2>> Wh_sale_h_Code2Asyunc(string sale_code);
        /// <summary>
        /// 审核
        /// </summary>
        /// <param name="sale_state"></param>
        /// <param name="sure_man"></param>
        /// <param name="sale_codeId"></param>
        /// <param name="sure_yj"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_h__sale_stateAsync(string sale_state, string sure_man, int sale_codeId, string sure_yj);
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="sale_codeId"></param>
        /// <returns></returns>
        Task<bool> Wh_sale_h__chexiaoAsync(string sure_man, int sale_codeId);
    }
}
