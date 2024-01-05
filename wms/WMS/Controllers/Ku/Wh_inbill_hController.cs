using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Collections;
using WMS.AppService.AppService.Ku;
using WMS.AppService.Dtos.Ku;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.Wh;
using WMS.EFCore;

namespace WMS.Controllers.Ku
{
    /// <summary>
    /// 入库管理
    /// </summary>
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Wh_inbill_hController : ControllerBase
    {
        private readonly IWh_inbill_hAppService hh;
        private readonly MyContext _context;

        public Wh_inbill_hController(IWh_inbill_hAppService hh, MyContext _context)
        {
            this.hh = hh;
            this._context = _context;
        }
        /// <summary>
        /// 查询全部
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<Wh_inbill_h>> Wh_inbill_hSelectAsync()
        {
            return await hh.Wh_inbill_hSelectAsync();
        }
       
        /// <summary>
        /// 分页查询
        /// </summary>北京不能看不能看你们不能看不能看本来
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        [HttpGet]
        public IActionResult Wh_inbill_hFenYeAsync(int page, int pageSize)
        {
            var products = hh.Wh_inbill_hFenYeAsync(page, pageSize);
            return Ok(products);
        }
        [HttpGet]
        public  async Task<Bs_supply> Bs_supplyName(string name)
        {
            return await hh.Bs_supplyName(name);
           
        }
        /// <summary>
        /// 模糊查询
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<Wh_inbill_h> Wh_inbill_hMHAsync(string bh)
        {
           
            return await hh.Wh_inbill_hMHAsync(bh);
         
            
        }
        /// <summary>
        /// 分页模糊查询
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="bh"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<FenYe<Wh_inbill_h>> Wh_inbill_hAsync(int page, int pageSize,string bh=null,string lx=null,string ck=null,string zt=null )
        {
            //string searchStr = string.IsNullOrEmpty(bh) ? "" : bh;
            //string searchStr1 = string.IsNullOrEmpty(bh) ? "" : lx;
            //string searchStr2 = string.IsNullOrEmpty(bh) ? "" : zt;
            //string searchStr3 = string.IsNullOrEmpty(bh) ? "" : ck;

            //var products = hh.Wh_inbill_hAsync(page,pageSize, bh, lx, zt, ck);
            //return Ok(products);

            return await hh.Wh_inbill_hAsync(page, pageSize, bh, lx, zt, ck);
        }
        /// <summary>
        /// 用户
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<Users>> FindUser()
        {
            return await hh.UserFind();
        }

        /// <summary>
        /// 用户
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<Users> UserID( string name,string pwd)
        {
            return await hh.UsersID(name, pwd);
        }
        /// <summary>
        /// 供应商
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<Bs_supply>> Bs_supplyFind()
        {
            return await hh.Bs_supplyFind();
        }

        /// <summary>
        /// 根据单号查入库详细
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<Wh_inbill_dXX>> Wh_inbill_dMHAsync(string bh)
        {
            return await hh.Wh_inbill_dMHAsync(bh);
        }
        /// <summary>
        /// 仓位
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<List<Bs_ware_area>> Bs_ware_areaName(string bh)
        {
            return await hh.Bs_ware_areaName(bh);
        }
        /// <summary>
        /// 订单详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        [HttpPost]
       
        public async Task<Fen<Wh_orderbuy_dXX>> Wh_orderbuy_dBH(int page, int pageSize, string str)
        {
            return await hh.Wh_orderbuy_dBH(page, pageSize, str);
        }

        /// <summary>
        /// 入库管理分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<Fen<ST>> Fen(int page, int pageSize, string str)
        {
            return await hh.FenYE(page, pageSize, str);
        }

        /// <summary>
        /// 进货订单分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<Fen<View>> FenOrder(int page, int pageSize, string str)
        {
            return await hh.Wh_buy_order_hFenYeAsync(page, pageSize, str);
        }

        /// <summary>
        /// 审核记录分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<Fen<Audit>> FenAudit(int page, int pageSize, string str)
        {
            return await hh.AuditFenYeAsync(page, pageSize, str);
        }

        /// <summary>
        /// 进货订单分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<Fen<Bb_view>> Hp(int page, int pageSize, string str)
        {
            return await hh.HP(page, pageSize, str);
        }

        /// <summary>
        /// 添加入库信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<bool> Wh_inbill_hAddAsync(AddWh_inbill_hDto addStudenDto)
        {
            return await hh.AddWh_inbill_hAsync(addStudenDto);
        }


        /// <summary>
        /// 添加库存
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<bool> Wh_now_storageAsync(string dh)
        {
            return await hh.Wh_now_storageAsync(dh);
        }
        /// <summary>
        /// 修改入库信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> Wh_inbill_hUpdateAsync(UpdateWh_inbill_hDto addStudenDto)
        {
            return await hh.UpdateWh_inbill_hAsync(addStudenDto);
        }
        /// <summary>
        /// 删除出库信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> Wh_inbill_hDeleteAsync(int addStudenDto)
        {
            return await hh.DeleteWh_inbill_hAsync(addStudenDto);
        }
        /// <summary>
        /// 批量删除入库信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPut("route")]
        public async Task<bool> Wh_inbill_hDeleteSAsync([FromBody] int[] sz)
        {
            return await hh.DeleteSWh_inbill_hAsync(sz);
        }

        /// <summary>
        /// 审核
        /// </summary>
      
        /// <returns></returns>
        [HttpPut()]
        public async Task<bool> Wh_inbill_hSHAsync(string name,int zt,int id,string desc,string ii)
        {
            return await hh.Wh_inbill_hSHAsync(zt,name,id,desc, ii);
        }

        /// <summary>
        /// 撤销
        /// </summary>

        /// <returns></returns>
        [HttpPut()]
        public async Task<bool> Wh_inbill_hCXAsync(string name,  string ii)
        {
            return await hh.Wh_inbill_hCXAsync (name, ii);
        }
        /// <summary>
        /// 添加入库（有关联单号）
        /// </summary>
        /// <param name="list"></param>
        /// <param name="list1"></param>
        /// <returns></returns>

        [HttpGet]
        public async Task<bool> KK(string arrayList,string xx)
        {
            Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(arrayList);
            ArrayList y = new ArrayList(dictionaryDeserialized.Values);
            List<Wh_orderbuy_dXX> w = JsonConvert.DeserializeObject<List<Wh_orderbuy_dXX>>(xx);
            return await hh.InsertWh_inbill_hAsync(y,w);

        }
        /// <summary>
        /// 修改入库（没有关联单号）
        /// </summary>
        /// <param name="arrayList"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> UpdateKK1(string arrayList, string xx)
        {
            Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(arrayList);
            ArrayList y = new ArrayList(dictionaryDeserialized.Values);
            List<Wh_inbill_dXX> w = JsonConvert.DeserializeObject<List<Wh_inbill_dXX>>(xx);
            return await hh.Update1Wh_inbill_hAsync(y, w);

        }
        /// <summary>
        /// 修改入库（有关联单号）
        /// </summary>
        /// <param name="arrayList"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> UpdateKK2(string arrayList, string xx)
        {
            Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(arrayList);
            ArrayList y = new ArrayList(dictionaryDeserialized.Values);
            List<Wh_inbill_dXX> w = JsonConvert.DeserializeObject<List<Wh_inbill_dXX>>(xx);
            return await hh.Update2Wh_inbill_hAsync(y, w);

        }
        /// <summary>
        /// 添加入库（没有关联单号）
        /// </summary>
        /// <param name="arrayList"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> KK1(string arrayList, string xx)
        {
            Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(arrayList);
            ArrayList y = new ArrayList(dictionaryDeserialized.Values);
            List<Wh_orderbuy_dXX> w = JsonConvert.DeserializeObject<List<Wh_orderbuy_dXX>>(xx);
            return await hh.Insert1Wh_inbill_hAsync(y, w);

        }
    }
}
