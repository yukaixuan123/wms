using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Collections;
using System.Runtime.Serialization;
using WMS.AppService.AppService.Ku;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.EFCore;

namespace WMS.Controllers.Ku
{
    /// <summary>
    /// 库存盘点
    /// </summary>
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Wh_inventory_hController : ControllerBase
    {
        private readonly IWh_inventory_hAppService hh;
        private readonly MyContext _context;

        public Wh_inventory_hController(IWh_inventory_hAppService hh, MyContext _context)
        {
            this.hh = hh;
            this._context = _context;
        }
        /// <summary>
        /// 详细
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<Wh_inventory_h> Wh_inventory_hMHAsync(string bh)
        {
            return await hh.Wh_inventory_hMHAsync(bh);
        }
        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<Wh_inventory_dXX>> Wh_inventory_dMHAsync(string bh)
        {
            return await hh.Wh_inventory_dMHAsync(bh);
        }
        /// <summary>
        /// 库存盘点分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>
      
        [HttpPost]
       
        public async Task<Fen<ST22>> Fen(int page, int pageSize, string str)
        {
            return await hh.FenYE(page, pageSize, str);
        }
        /// <summary>
        /// 添加盘点
        /// </summary>
        /// <param name="arrayList"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Insert(string arrayList, string xx)
        {
            Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(arrayList);
            ArrayList y = new ArrayList(dictionaryDeserialized.Values);
            List<Wh_sale_dXX> w = JsonConvert.DeserializeObject<List<Wh_sale_dXX>>(xx);
            return await hh.InsertWh_inventory_hAsync(y, w);

        }
        /// <summary>
        /// 修改盘点
        /// </summary>
        /// <param name="arrayList"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Update(string arrayList, string xx)
        {
            Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(arrayList);
            ArrayList y = new ArrayList(dictionaryDeserialized.Values);
            List<Wh_inventory_dXX> w = JsonConvert.DeserializeObject<List<Wh_inventory_dXX>>(xx);
            return await hh.UpdateWh_inventory_hAsync(y, w);

        }
        [HttpPut]
        //审核
        public async Task<bool> Wh_inventory_hSHAsync(int zt, string name, string desc, string ii)
        {
            return await hh.Wh_inventory_hSHAsync(zt,name, desc, ii);
        }
        /// <summary>
        /// 删除信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> Wh_inventory_hDeleteAsync(string addStudenDto)
        {
            return await hh.DeleteWh_inventory_hAsync(addStudenDto);
        }
        /// <summary>
        /// 批量删除信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPut("route")]
        public async Task<bool> Wh_inventory_hDeleteSAsync([FromBody] int[] sz)
        {
            return await hh.DeleteSWh_inventory_hAsync(sz);
        }
    }
}
