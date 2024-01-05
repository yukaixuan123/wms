using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Wh;

namespace WMS.AppService.AppService.Wh
{
    public class Wh_sale_hAppService:IWh_sale_hAppService
    {
        private readonly IWh_sale_hRepository or;
        private readonly IMapper mapper;
        public Wh_sale_hAppService(IWh_sale_hRepository or, IMapper mapper)
        {
            this.or = or;
            this.mapper = mapper;
        }
        /// <summary>
        /// 销售订单查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<FenYeDapper<View_Sale_h>> Wh_sale_hFenYeAsync(int pageSize, int currentPage, string str)
        {
            return or.Wh_sale_hFenYeAsync(pageSize,currentPage,str);
        }
        /// <summary>
        /// 销售货品查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<FenYeDapper<View_XSGoods>> Wh_sale_hGoodsFenYeAsync(int pageSize, int currentPage, string str)
        {
            return or.Wh_sale_hGoodsFenYeAsync(pageSize, currentPage, str);
        }

        /// <summary>
        /// 根据客户名称查全部信息
        /// </summary>
        /// <param name="cust_name"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<Bs_customer> Wh_sale_hNameAsyunc(string cust_name)
        {
            return or.Wh_sale_hNameAsyunc(cust_name);
        }
        /// <summary>
        /// 查客户信息
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<Bs_customer>> Wh_sale_hYHAsyunc()
        {
            return or.Wh_sale_hYHAsyunc();
        }
        /// <summary>
        /// 销售订单明细
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<Wh_sale_d>> Wh_sale_h_Code1Asyunc(string sale_code)
        {
            return or.Wh_sale_h_Code1Asyunc(sale_code);
        }
        /// <summary>
        /// 销售出库
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<ST2>> Wh_sale_h_Code2Asyunc(string sale_code)
        {
            return or.Wh_sale_h_Code2Asyunc(sale_code);
        }

        /// <summary>
        /// 销售订单基本信息
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<View_Sale_h> Wh_sale_h_CodeAsyunc(string sale_code)
        {
            return or.Wh_sale_h_CodeAsyunc(sale_code);
        }

        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_h_DeleteArryAsync(int[] carModel)
        {
            return or.Wh_sale_h_DeleteArryAsync(carModel);
        }

        /// <summary>
        /// 销售订单删除
        /// </summary>
        /// <param name="sale_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_h_DeleteAsync(int sale_codeId)
        {
            return or.Wh_sale_h_DeleteAsync(sale_codeId);
        }

        /// <summary>
        /// 销售订单添加
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        public Task<bool> Wh_sale_h_InsertAsync(List<Wh_sale_d> dd, Wh_sale_h h)
        {
            return or.Wh_sale_h_InsertAsync(dd, h);
        }
        /// <summary>
        /// 销售订单修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_h_UpdateAsync(List<Wh_sale_d> dd, Wh_sale_h h)
        {
            return or.Wh_sale_h_UpdateAsync(dd, h);
        }
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="sale_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_h__chexiaoAsync(string sure_man, int sale_codeId)
        {
            return or.Wh_sale_h__chexiaoAsync(sure_man,sale_codeId);
        }
        /// <summary>
        /// 审核
        /// </summary>
        /// <param name="sale_state"></param>
        /// <param name="sure_man"></param>
        /// <param name="sale_codeId"></param>
        /// <param name="sure_yj"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_h__sale_stateAsync(string sale_state, string sure_man, int sale_codeId, string sure_yj)
        {
            return or.Wh_sale_h__sale_stateAsync(sale_state,sure_man,sale_codeId,sure_yj);
        }
    }
}
