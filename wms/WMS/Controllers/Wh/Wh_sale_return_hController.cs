using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using WMS.AppService.AppService.Wh;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Wh;
using WMS.EFCore;

namespace WMS.Controllers.Wh
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Wh_sale_return_hController : ControllerBase
    {
        private readonly IWh_sale_return_hAppService or;
        private readonly MyContext _context;
        public Wh_sale_return_hController(IWh_sale_return_hAppService or, MyContext _context)
        {
            this.or = or;
            this._context = _context;
        }
        [HttpGet]
        public Task<IEnumerable<Wh_saleReturn_dXX>> Wh_sale_return_h__srlAsyunc(string sr_code)
        {
            return or.Wh_sale_return_h__srlAsyunc(sr_code);
        }
        /// <summary>
        /// 销售退货添加
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Wh_sale_return_h_InsertAsync(string json, string xx)
        {
            List<Wh_sale_return_d> a = JsonConvert.DeserializeObject<List<Wh_sale_return_d>>(json);
            Wh_sale_return_h b = JsonConvert.DeserializeObject<Wh_sale_return_h>(xx);
            return await or.Wh_sale_return_h_InsertAsync(a, b);
        }
        [HttpGet]
        public Task<IEnumerable<ST1>> Wh_sale_return_h__sr213lAsyunc(string inbill_bh)
        {
            return or.Wh_sale_return_h__sr213lAsyunc(inbill_bh);
        }

        [HttpGet]

        public async Task<bool> Wh_sale_return_h_sale_inserAsync(string json, string xx)
        {
            List<Wh_saleReturn_dXX> a = JsonConvert.DeserializeObject<List<Wh_saleReturn_dXX>>(json);
            Wh_inbill_h b = JsonConvert.DeserializeObject<Wh_inbill_h>(xx);
            return await or.Wh_sale_return_h_sale_inserAsync(a, b);
        }

        /// <summary>
        /// 销售退货修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public async Task<bool> Wh_sale_return_h_UpdateAsync(string json, string xx)
        {
            List<Wh_sale_return_d> a = JsonConvert.DeserializeObject<List<Wh_sale_return_d>>(json);
            Wh_sale_return_h b = JsonConvert.DeserializeObject<Wh_sale_return_h>(xx);
            return await or.Wh_sale_return_h_UpdateAsync(a, b);
        }
        /// <summary>
        /// 销售退货查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<FenYeDapper<View_sale_return_h>> Wh_sale_return_h_FenYeAsync(int pageSize, int currentPage, string str)
        {
            return or.Wh_sale_return_h_FenYeAsync(pageSize, currentPage, str);
        }

        /// <summary>
        /// 退货查详细信息
        /// </summary>
        /// <param name="sr_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
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
        [HttpGet]
        public Task<View_sale_return_h> Wh_sale_return_h_CodeAsyunc(string sr_code)
        {
            return or.Wh_sale_return_h_CodeAsyunc(sr_code);
        }
        /// <summary>
        /// 根据销售订单查退货记录
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<IEnumerable<Wh_sale_return_h>> Wh_sale_return_h__thjlAsyunc(string sale_code)
        {
            return or.Wh_sale_return_h__thjlAsyunc(sale_code);
        }
        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpPut("route")]
        public Task<bool> Wh_sale_return_h_DeleteArryAsync([FromBody] int[] carModel)
        {
            return or.Wh_sale_return_h_DeleteArryAsync(carModel);
        }
        /// <summary>
        /// 销售退货删除
        /// </summary>
        /// <param name="sr_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpPut]
        public Task<bool> Wh_sale_return_h_DeleteAsync(int sr_codeId)
        {
            return or.Wh_sale_return_h_DeleteAsync(sr_codeId);
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
        [HttpPut]
        public Task<bool> Wh_sale_return_h_sale_state1Async(string sale_state, string sure_man, string sale_yj, string sr_codeId)
        {
            return or.Wh_sale_return_h_sale_state1Async(sale_state, sure_man, sale_yj, sr_codeId);
        }
        [HttpGet]
        public async Task<bool> Wh_sale_return_h_sale_stateAsync(string json, string xx)
        {
            List<Wh_sale_d> a = JsonConvert.DeserializeObject<List<Wh_sale_d>>(json);
            Wh_sale_return_h b = JsonConvert.DeserializeObject<Wh_sale_return_h>(xx);
            return await or.Wh_sale_return_h_sale_stateAsync(a, b);
        }
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="sr_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpPut]
        public Task<bool> Wh_sale_return_h_chexiaoAsync(string sure_man, int sr_codeId)
        {
            return or.Wh_sale_return_h_chexiaoAsync(sure_man, sr_codeId);
        }
    }
}
