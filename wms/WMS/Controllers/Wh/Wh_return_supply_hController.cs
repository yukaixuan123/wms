using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
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
    public class Wh_return_supply_hController : ControllerBase
    {
        private readonly IWh_return_supply_hAppService or;
        private readonly MyContext _context;
        public Wh_return_supply_hController(IWh_return_supply_hAppService or, MyContext _context)
        {
            this.or = or;
            this._context = _context;
        }
        [HttpGet]
        public  Task<IEnumerable<Wh_GoodsReturn_dXX>> Wh_return_supply_h_t213Asyunc(string returns_code)
        {
            return  or.Wh_return_supply_h_t213Asyunc(returns_code);
        }
        [HttpGet]
        public Task<IEnumerable<ST2>> Wh_return_supply_h_sr213lAsyunc(string outbill_bh)
        {
            return or.Wh_return_supply_h_sr213lAsyunc(outbill_bh);
        }
        /// <summary>
        /// 进货退货添加
        /// </summary>
        /// <param name="json"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Wh_return_supply_h_InsertAsync(string json, string xx)
        {
            List<Wh_return_supply_d> a = JsonConvert.DeserializeObject<List<Wh_return_supply_d>>(json);
            Wh_return_supply_h b = JsonConvert.DeserializeObject<Wh_return_supply_h>(xx);
            return await or.Wh_return_supply_h_InsertAsync(a,b);
        }

        [HttpGet]
        public async Task<bool> Wh_return_supply_h_inse123rAsync(string json, string xx)
        {
            List<Wh_GoodsReturn_dXX> a = JsonConvert.DeserializeObject<List<Wh_GoodsReturn_dXX>>(json);
            Wh_outbill_h b = JsonConvert.DeserializeObject<Wh_outbill_h>(xx);
            return await or.Wh_return_supply_h_inse123rAsync(a, b);
        }

        /// <summary>
        /// 进货退货修改
        /// </summary>
        /// <param name="json"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Wh_return_supply_h_UpdateAsync(string json, string xx)
        {
            List<Wh_return_supply_d> a = JsonConvert.DeserializeObject<List<Wh_return_supply_d>>(json);
            Wh_return_supply_h b = JsonConvert.DeserializeObject<Wh_return_supply_h>(xx);
            return await or.Wh_return_supply_h_UpdateAsync(a, b);
        }
        /// <summary>
        /// 审核意见
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Wh_return_supply_h_sale_stateAsync(string json, string xx)
        {
            List<Wh_orderbuy_d> a = JsonConvert.DeserializeObject<List<Wh_orderbuy_d>>(json);
            Wh_return_supply_h b = JsonConvert.DeserializeObject<Wh_return_supply_h>(xx);
            return await or.Wh_return_supply_h_sale_stateAsync(a, b);
        }
        [HttpPut]

        public Task<bool> Wh_return_supply_h_sale_state1Async(string sale_state, string sure_man, string sure_yj, string buy_codeId)
        {
            return or.Wh_return_supply_h_sale_state1Async(sale_state, sure_man, sure_yj, buy_codeId);
        }

        /// <summary>
        /// 进货退货分页查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpGet]
        public Task<FenYeDapper<View_Return_supply>> Wh_return_supply_hFenYeAsync(int pageSize, int currentPage, string str)
        {
            return or.Wh_return_supply_hFenYeAsync(pageSize, currentPage, str);
        }
        /// <summary>
        /// 进货退货删除
        /// </summary>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        [HttpPut]
        public Task<bool> Wh_return_supply_h_DeleteAsync(int buy_codeId)
        {
            return or.Wh_return_supply_h_DeleteAsync(buy_codeId);
        }

        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpPut("route")]
        public Task<bool> Wh_return_supply_h_DeleteArryAsync([FromBody] int[] carModel)
        {
            return or.Wh_return_supply_h_DeleteArryAsync(carModel);
        }

        /// <summary>
        /// 根据退货单号查详细信息
        /// </summary>
        /// <param name="returns_code"></param>
        /// <returns></returns>
        [HttpGet]
        public Task<IEnumerable<Wh_return_supply_d>> Wh_return_supply_h_Code1Asyunc(string returns_code)
        {
            return or.Wh_return_supply_h_Code1Asyunc(returns_code);
        }
        /// <summary>
        /// 根据退货单号查基本信息
        /// </summary>
        /// <param name="returns_code"></param>
        /// <returns></returns>
        [HttpGet]
        public Task<View_Return_supply> Wh_return_supply_h_CodeAsyunc(string returns_code)
        {
            return or.Wh_return_supply_h_CodeAsyunc(returns_code);
        }
        /// <summary>
        /// 根据进货订单查退货记录
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        [HttpGet]
        public  Task<IEnumerable<Wh_return_supply_h>> Wh_return_supply_h_thjlAsyunc(string buy_code)
        {
            return or.Wh_return_supply_h_thjlAsyunc(buy_code);
        }

        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpPut]
        public Task<bool> Wh_return_supply_h_chexiaoAsync(string sure_man, int buy_codeId)
        {
            return or.Wh_return_supply_h_chexiaoAsync(sure_man, buy_codeId);
        }
    }
   
}
