using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Wh;

namespace WMS.AppService.AppService.Wh
{
    public class Wh_sale_return_hAppService: IWh_sale_return_hAppService
    {
        private readonly IWh_sale_return_hRepository or;
        private readonly IMapper mapper;
        public Wh_sale_return_hAppService(IWh_sale_return_hRepository or, IMapper mapper)
        {
            this.or = or;
            this.mapper = mapper;
        }
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="sr_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_return_h_chexiaoAsync(string sure_man, int sr_codeId)
        {
            return or.Wh_sale_return_h_chexiaoAsync(sure_man, sr_codeId);
        }

        /// <summary>
        /// 退货查详细信息
        /// </summary>
        /// <param name="sr_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<Wh_sale_return_d>> Wh_sale_return_h_Code1Asyunc(string sr_code)
        {
            return or.Wh_sale_return_h_Code1Asyunc(sr_code);
        }
        /// <summary>
        /// 退货查基本信息
        /// </summary>
        /// <param name="sr_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<View_sale_return_h> Wh_sale_return_h_CodeAsyunc(string sr_code)
        {
            return or.Wh_sale_return_h_CodeAsyunc(sr_code);
        }
        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_return_h_DeleteArryAsync(int[] carModel)
        {
            return or.Wh_sale_return_h_DeleteArryAsync(carModel);
        }
        /// <summary>
        /// 销售退货删除
        /// </summary>
        /// <param name="sr_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_return_h_DeleteAsync(int sr_codeId)
        {
            return or.Wh_sale_return_h_DeleteAsync(sr_codeId);
        }
        /// <summary>
        /// 销售退货查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<FenYeDapper<View_sale_return_h>> Wh_sale_return_h_FenYeAsync(int pageSize, int currentPage, string str)
        {
            return or.Wh_sale_return_h_FenYeAsync(pageSize, currentPage, str);
        }

        /// <summary>
        /// 销售退货添加
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_return_h_InsertAsync(List<Wh_sale_return_d> dd, Wh_sale_return_h h)
        {
            return or.Wh_sale_return_h_InsertAsync(dd, h);
        }

        public Task<bool> Wh_sale_return_h_sale_inserAsync(List<Wh_saleReturn_dXX> dd, Wh_inbill_h h)
        {
            return or.Wh_sale_return_h_sale_inserAsync(dd, h);
        }

        /// <summary>
        /// 审核
        /// </summary>
        /// <param name="sale_state"></param>
        /// <param name="sure_man"></param>
        /// <param name="sale_yj"></param>
        /// <param name="sr_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_return_h_sale_state1Async(string sale_state, string sure_man, string sale_yj, string sr_codeId)
        {
            return or.Wh_sale_return_h_sale_state1Async(sale_state, sure_man, sale_yj, sr_codeId);
        }

        public Task<bool> Wh_sale_return_h_sale_stateAsync(List<Wh_sale_d> dd, Wh_sale_return_h h)
        {
            return or.Wh_sale_return_h_sale_stateAsync (dd, h);
        }

        /// <summary>
        /// 销售退货修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<bool> Wh_sale_return_h_UpdateAsync(List<Wh_sale_return_d> dd, Wh_sale_return_h h)
        {
            return or.Wh_sale_return_h_UpdateAsync (dd, h);
        }

        public Task<IEnumerable<ST1>> Wh_sale_return_h__sr213lAsyunc(string inbill_bh)
        {
            return or.Wh_sale_return_h__sr213lAsyunc(inbill_bh);
        }

        public Task<IEnumerable<Wh_saleReturn_dXX>> Wh_sale_return_h__srlAsyunc(string sr_code)
        {
            return or.Wh_sale_return_h__srlAsyunc(sr_code);
        }

        /// <summary>
        /// 根据销售订单查退货记录
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<Wh_sale_return_h>> Wh_sale_return_h__thjlAsyunc(string sale_code)
        {
            return or.Wh_sale_return_h__thjlAsyunc (sale_code);
        }
    }
}
