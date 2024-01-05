using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Collections;
using WMS.AppService.AppService.Ku;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sup;
using WMS.EFCore;

namespace WMS.Controllers.Ku
{
    /// <summary>
    /// 出库管理
    /// </summary>
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Wh_outbill_hController : ControllerBase
    {
        private readonly IWh_outbill_hAppService hh;
        private readonly MyContext _context;

        public Wh_outbill_hController(IWh_outbill_hAppService hh, MyContext _context)
        {
            this.hh = hh;
            this._context = _context;
        }
        /// <summary>
        /// 客户
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<Bs_customer>> Bs_customerFind()
        {
            return await hh.Bs_customerFind();
        }
        /// <summary>
        /// 根据名字找客户
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<Bs_customer> Bs_customerName(string name)
        {
            return await hh.Bs_customerName(name);

        }
        /// <summary>
        /// 根据名字找仓库
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<Bs_warehouse> Bs_warehouseName(string name)
        {
            return await hh.Bs_warehouseName(name);

        }

        /// <summary>
        /// 仓库
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task< List<string>> Ku(int id)
        {
            return await hh.Ku(id);
        }
        /// <summary>
        /// 仓库
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<string>> Ku1()
        {
            return await hh.Ku1();
        }

        /// <summary>
        /// 货品
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<string[]> Hp(string ck)
        {
            return await hh.Hp(ck);
        }

        /// <summary>
        /// 进货订单分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<Fen<View_Sale>> FenOrder(int page, int pageSize, string str)
        {
            return await hh.Wh_sale_hFenYeAsync(page, pageSize, str);
        }

        /// <summary>
        /// 销售详细
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<List<Wh_sale_dXX>> Wh_sale_BH( string str)
        {
            return await hh.Wh_sale_BH(str);
        }
        /// <summary>
        /// 货品库存
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<Wh_now_storage> Num(string hp, string kw)
        {
            return await hh.Num(hp,kw);
        }
        /// <summary>
        /// 出库管理分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<Fen<ST11>> Fen(int page, int pageSize, string str)
        {
            return await hh.FenYE(page, pageSize, str);
        }
        /// <summary>
        /// 添加出库（没有关联单号）
        /// </summary>
        /// <param name="arrayList"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> KK1(string arrayList, string xx)
        {
            Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(arrayList);
            ArrayList y = new ArrayList(dictionaryDeserialized.Values);
            List<Wh_sale_dXX> w = JsonConvert.DeserializeObject<List<Wh_sale_dXX>>(xx);
            return await hh.Insert1Wh_outbill_hAsync(y, w);

        }

        /// <summary>
        /// 添加出库（有关联单号）
        /// </summary>
        /// <param name="arrayList"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> KK(string arrayList, string xx)
        {
            Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(arrayList);
            ArrayList y = new ArrayList(dictionaryDeserialized.Values);
            List<Wh_sale_dXX> w = JsonConvert.DeserializeObject<List<Wh_sale_dXX>>(xx);
            return await hh.InsertWh_outbill_hAsync(y, w);

        }

        /// <summary>
        /// 根据单号查出库详细
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<Wh_outbill_dXX>> Wh_outbill_dMHAsync(string bh)
        {
            return await hh.Wh_outbill_dMHAsync(bh);
        }

        /// <summary>
        /// 详细
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<Wh_outbill_h> Wh_outbill_hMHAsync(string bh)
        {
            return await hh.Wh_outbill_hMHAsync(bh);
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
            List<Wh_outbill_dXX> w = JsonConvert.DeserializeObject<List<Wh_outbill_dXX>>(xx);
            return await hh.Update1Wh_outbill_hAsync(y, w);

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
            List<Wh_outbill_dXX> w = JsonConvert.DeserializeObject<List<Wh_outbill_dXX>>(xx);
            return await hh.Update2Wh_outbill_hAsync(y, w);

        }
        /// <summary>
        /// 删除入库信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> Wh_outbill_hDeleteAsync(string addStudenDto)
        {
            return await hh.DeleteWh_outbill_hAsync(addStudenDto);
        }
        /// <summary>
        /// 批量删除入库信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPut("route")]
        public async Task<bool> Wh_outbill_hDeleteSAsync([FromBody] int[] sz)
        {
            return await hh.DeleteSWh_outbill_hAsync(sz);
        }
        /// <summary>
        /// 审核
        /// </summary>

        /// <returns></returns>
        [HttpPut()]
        public async Task<bool> Wh_outbill_hSHAsync(string name, int zt, string desc, string ii)
        {
            return await hh.Wh_outbill_hSHAsync(zt, name, desc, ii);
        }
        /// <summary>
        /// 改变库存
        /// </summary>

        /// <returns></returns>
        [HttpPost]
        public async Task<bool> Wh_now_storageAsync(string dh)
        {
            return await hh.Wh_now_storageAsync(dh);
        }
    }
}
