using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using WMS.AppService.AppService.Wh;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.Wh;
using WMS.EFCore;

namespace WMS.Controllers.Wh
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Wh_sale_hController : ControllerBase
    {
        private readonly IWh_sale_hAppService or;
        private readonly MyContext _context;
        public Wh_sale_hController(IWh_sale_hAppService or, MyContext _context)
        {
            this.or = or;
            this._context = _context;
        }
        /// <summary>
        /// 根据客户名称查全部信息
        /// </summary>
        /// <param name="cust_name"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<Bs_customer> Wh_sale_hNameAsyunc(string cust_name)
        {
            return or.Wh_sale_hNameAsyunc(cust_name);
        }
        /// 查客户信息
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<IEnumerable<Bs_customer>> Wh_sale_hYHAsyunc()
        {
            return or.Wh_sale_hYHAsyunc();
        }

        /// <summary>
        /// 销售订单添加
        /// </summary>
        /// <param name="json"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Wh_sale_h_InsertAsync(string json, string xx)
        {
            List<Wh_sale_d> a = JsonConvert.DeserializeObject<List<Wh_sale_d>>(json);
            Wh_sale_h b = JsonConvert.DeserializeObject<Wh_sale_h>(xx);
            return await or.Wh_sale_h_InsertAsync(a, b);
        }
        /// <summary>
        /// 销售订单修改
        /// </summary>
        /// <param name="json"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Wh_sale_h_UpdateAsync(string json, string xx)
        {
            List<Wh_sale_d> a = JsonConvert.DeserializeObject<List<Wh_sale_d>>(json);
            Wh_sale_h b = JsonConvert.DeserializeObject<Wh_sale_h>(xx);
            return await or.Wh_sale_h_UpdateAsync(a, b);
        }
        /// <summary>
        /// 销售订单查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<FenYeDapper<View_Sale_h>> Wh_sale_hFenYeAsync(int pageSize, int currentPage, string str)
        {
            return await or.Wh_sale_hFenYeAsync(pageSize, currentPage, str);
        }
        /// <summary>
        /// 销售货品查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpGet]
        public Task<FenYeDapper<View_XSGoods>> Wh_sale_hGoodsFenYeAsync(int pageSize, int currentPage, string str)
        {
            return or.Wh_sale_hGoodsFenYeAsync(pageSize, currentPage, str);
        }

        /// <summary>
        /// 销售订单删除
        /// </summary>
        /// <param name="sale_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpPut]
        public async Task<bool> Wh_sale_h_DeleteAsync(int sale_codeId)
        {
            return await or.Wh_sale_h_DeleteAsync(sale_codeId);
        }

        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpPut("route")]
        public Task<bool> Wh_sale_h_DeleteArryAsync([FromBody] int[] carModel)
        {
            return or.Wh_sale_h_DeleteArryAsync(carModel);
        }

        /// <summary>
        /// 销售订单明细
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<IEnumerable<Wh_sale_d>> Wh_sale_h_Code1Asyunc(string sale_code)
        {
            return or.Wh_sale_h_Code1Asyunc(sale_code);
        }
        /// <summary>
        /// 销售订单基本信息
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<View_Sale_h> Wh_sale_h_CodeAsyunc(string sale_code)
        {
            return or.Wh_sale_h_CodeAsyunc(sale_code);
        }
        /// <summary>
        /// 销售出库
        /// </summary>
        /// <param name="sale_code"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<IEnumerable<ST2>> Wh_sale_h_Code2Asyunc(string sale_code)
        {
            return or.Wh_sale_h_Code2Asyunc(sale_code);
        }
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="sale_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpPut]
        public Task<bool> Wh_sale_h__chexiaoAsync(string sure_man, int sale_codeId)
        {
            return or.Wh_sale_h__chexiaoAsync(sure_man, sale_codeId);
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
        [HttpPut]
        public Task<bool> Wh_sale_h__sale_stateAsync(string sale_state, string sure_man, int sale_codeId, string sure_yj)
        {
            return or.Wh_sale_h__sale_stateAsync(sale_state, sure_man, sale_codeId, sure_yj);
        }
    }
}
