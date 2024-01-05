using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using WMS.AppService.AppService.Ku;
using WMS.AppService.AppService.Wh;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.Wh;
using WMS.EFCore;

namespace WMS.Controllers.Wh
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Wh_buy_order_hController : ControllerBase
    {
        private readonly IWh_buy_order_hAppService or;
        private readonly MyContext _context;

        public Wh_buy_order_hController(IWh_buy_order_hAppService or, MyContext _context)
        {
            this.or = or;
            this._context = _context;
        }
        /// <summary>
        /// 进货订单
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<FenYeDapper<View_Order>> Wh_buy_order_hFindAsync(int pageSize, int currentPage, string str)
        {
            return await or.Wh_buy_order_hFenYeAsync(pageSize, currentPage, str);
        }
        /// <summary>
        /// 根据单号查进货订单
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<View_Order> Wh_buy_order_h_CodeAsyunc(string buy_code)
        {
            return await or.Wh_buy_order_h_CodeAsyunc(buy_code);
        }

        /// <summary>
        /// 货品信息
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<FenYeDapper<View_Bs_Item>> Bs_item_FindAsync(int pageSize, int currentPage, string str)
        {
            return await or.Bs_item_FenYeAsync(pageSize, currentPage, str);
        }
        /// <summary>
        /// 进货订单删除
        /// </summary>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> Wh_buy_order_h_DeleteAsync(int buy_codeId)
        {
            return await or.Wh_buy_order_h_DeleteAsync(buy_codeId);
        }
        /// <summary>
        /// 进货订单添加
        /// </summary>
        /// <param name="json"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Wh_buy_order_h_InserttAsync(string json,string xx)
        {
            List<Wh_orderbuy_d> a=JsonConvert.DeserializeObject<List<Wh_orderbuy_d>>(json);
            Wh_buy_order_h b = JsonConvert.DeserializeObject<Wh_buy_order_h>(xx);
            return await or.Wh_buy_order_h_InsertAsync(a,b);
        }

        /// <summary>
        /// 进货订单修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Wh_buy_order_h_UpdateAsync(string json, string xx)
        {
            List<Wh_orderbuy_d> a = JsonConvert.DeserializeObject<List<Wh_orderbuy_d>>(json);
            Wh_buy_order_h b = JsonConvert.DeserializeObject<Wh_buy_order_h>(xx);
            return await or.Wh_buy_order_h_UpdateAsync(a,b);
        }
        /// <summary>
        /// 查用户
        /// </summary>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        [HttpGet]
        public Task<Users> UsersID(string username, string password)
        {
            return or.UsersID(username, password);
        }
        [HttpGet]
        public Task<IEnumerable<Wh_orderbuy_d>> Wh_buy_order_h_Code1Asyunc(string buy_code)
        {
            return or.Wh_buy_order_h_Code1Asyunc(buy_code);
        }
        [HttpGet]

        public Task<IEnumerable<ST1>> Wh_buy_order_h_Code2Asyunc(string buy_code)
        {
            return or.Wh_buy_order_h_Code2Asyunc(buy_code);
        }
        /// <summary>
        /// 审核
        /// </summary>
        /// <param name="h"></param>
        /// <returns></returns>
        [HttpPut]
        public Task<bool> Wh_buy_order_h_sale_stateAsync(string sale_state, string sure_man, int buy_codeId, string sale_state_yj)
        {
            return or.Wh_buy_order_h_sale_stateAsync(sale_state,sure_man,buy_codeId, sale_state_yj);
        }
        [HttpPut]
        public Task<bool> Wh_buy_order_h_chexiaoAsync(string sure_man, int buy_codeId)
        {
            return or.Wh_buy_order_h_chexiaoAsync(sure_man, buy_codeId);
        }

        /// <summary>
        /// 进货订单批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        [HttpPut("route")]
        public Task<bool> Wh_buy_order_h_DeleteArryAsync([FromBody] int[] carModel)
        {
            return or.Wh_buy_order_h_DeleteArryAsync(carModel);
        }


        /// <summary>
        /// 用户信息
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<Users>> UserFindAsync()
        {
            return await or.UserFind();
        }
        /// <summary>
        /// 供应商信息
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<Bs_supply>> SuplyFind()
        {
            return await or.SuplyFind();
        }
        /// <summary>
        /// 根据名字供应商信息
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<Bs_supply> SuplyFindName(string name)
        {
            return await or.SuplyFindName(name);
        }
    }
}
