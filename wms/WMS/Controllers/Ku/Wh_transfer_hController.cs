using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Collections;
using WMS.AppService.AppService.Ku;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.EFCore;

namespace WMS.Controllers.Ku
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Wh_transfer_hController : ControllerBase
    {
        private readonly IWh_transfer_hAppService hh;
        private readonly MyContext _context;

        public Wh_transfer_hController(IWh_transfer_hAppService hh, MyContext _context)
        {
            this.hh = hh;
            this._context = _context;
        }
        /// <summary>
        /// 添加调拨
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
            return await hh.InsertWh_transfer_hAsync(y, w);

        }
        /// <summary>
        /// 修改调拨
        /// </summary>
        /// <param name="arrayList"></param>
        /// <param name="xx"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> Update(string arrayList, string xx)
        {
            Dictionary<string, object> dictionaryDeserialized = JsonConvert.DeserializeObject<Dictionary<string, object>>(arrayList);
            ArrayList y = new ArrayList(dictionaryDeserialized.Values);
            List<Wh_transfer_dXX> w = JsonConvert.DeserializeObject<List<Wh_transfer_dXX>>(xx);
            return await hh.UpdateWh_transfer_hAsync(y, w);

        }

        /// <summary>
        /// 库存调拨分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>

        [HttpPost]

        public async Task<Fen<ST33>> Fen(int page, int pageSize, string str)
        {
            return await hh.FenYE(page, pageSize, str);
        }
        /// <summary>
        /// 单位
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<string>> DW()
        {
            return await hh.DW();
        }
        /// <summary>
        /// 单位
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<string>> LX()
        {
            return await hh.LX();
        }
        /// <summary>
        /// 单位
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<List<string>> CRLX()
        {
            return await hh.CRLX();
        }
        /// <summary>
        /// 库存查询分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>

        [HttpPost]

        public async Task<Fen<Inventory>> KuFen(int page, int pageSize, string str)
        {
            return await hh.KuFen(page, pageSize, str);
        }

        /// <summary>
        /// 库存流水分页
        /// </summary>
        /// <param name="page"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>

        [HttpPost]

        public async Task<Fen<LIU>> LiuFen(int page, int pageSize, string str)
        {
            return await hh.LiuFen(page, pageSize, str);
        }

        [HttpGet]
        //详细信息
        public async Task<Wh_transfer_h> Wh_transfer_hMHAsync(string bh)
        {
            return await hh.Wh_transfer_hMHAsync(bh);
        }
        [HttpGet]
        //详细信息
        public async Task<List<Wh_transfer_dXX>> Wh_transfer_dMHAsync(string bh)
        {
            return await hh.Wh_transfer_dMHAsync(bh);
        }
        [HttpGet]
        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<List<Inventory>> KCXXAsync(string bh)
        {
            return await hh.KCXXAsync(bh);
        }
        [HttpGet]
        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<Inventory> KCXAsync(string bh)
        {
            return await hh.KCXAsync(bh);
        }
        [HttpPut]
        //审核
        public async Task<bool> Wh_transfer_hSHAsync(int zt, string name, string desc, string ii)
        {
            return await hh.Wh_transfer_hSHAsync(zt, name, desc, ii);
        }

        /// <summary>
        /// 删除信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> Wh_transfer_hDeleteAsync(string addStudenDto)
        {
            return await hh.DeleteWh_transfer_hAsync(addStudenDto);
        }
        /// <summary>
        /// 批量删除信息
        /// </summary>
        /// <param name="addStudenDto"></param>
        /// <returns></returns>
        [HttpPut("route")]
        public async Task<bool> Wh_transfer_hDeleteSAsync([FromBody] int[] sz)
        {
            return await hh.DeleteSWh_transfer_hAsync(sz);
        }
    }
}
