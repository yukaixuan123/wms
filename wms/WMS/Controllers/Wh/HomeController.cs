using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WMS.AppService.AppService.Wh;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Wh;
using WMS.EFCore;

namespace WMS.Controllers.Wh
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class HomeController : ControllerBase
    {
        private readonly IHomeAppService or;
        private readonly MyContext _context;
        public HomeController(IHomeAppService or, MyContext _context)
        {
            this.or = or;
            this._context = _context;
        }
        /// <summary>
        /// 全部待审核
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<IEnumerable<Alldsh>> ALLdskAsync()
        {
            return or.ALLdskAsync();
        }
        /// <summary>
        /// 全部待入库
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public int ALLrkAsync()
        {
            return or.ALLrkAsync();
        }
        /// <summary>
        /// 全部待出库
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public int ALLckAsync()
        {
            return or.ALLckAsync();
        }
        /// <summary>
        /// 入库统计
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public async Task<IEnumerable<ST1>> HomeRKAsync()
        {
            return await or.HomeRKAsync();
        }

        /// <summary>
        /// 出库统计
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public async Task<IEnumerable<ST2>> HomeCKAsync()
        {
            return await or.HomeCKAsync();
        }
        /// <summary>
        /// 库存货品数量占比
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<IEnumerable<Wh_now_storage1>> HomeHPSLAsync()
        {
            return or.HomeHPSLAsync();
        }
        /// <summary>
        /// 库存数量占比
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public Task<IEnumerable<Wh_now_storage>> HomeSLAsync()
        {
            return or.HomeSLAsync();
        }
        [HttpGet]
        public int hpslSUM()
        {
            return or.hpslSUM();
        }
        [HttpGet]
        public int kcslSUM()
        {
            return or.kcslSUM();
        }
        /// <summary>
        /// 入库今
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public async Task<ToYesCount> ToCountRKAsync()
        {
            return await or.ToCountRKAsync();
        }
        /// <summary>
        /// 入库昨
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public async Task<ToYesCount> YesCountRKAsync()
        {
            return await or.YesCountRKAsync();
        }
        /// <summary>
        /// 出库今
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public async Task<ToYesCount> ToCountCKAsync()
        {
            return await or.ToCountCKAsync();
        }
        /// <summary>
        /// 出库昨
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]
        public async Task<ToYesCount> YesCountCKAsync()
        {
            return await or.YesCountCKAsync();
        }

        /// <summary>
        /// 入库排名
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]

        public async Task<IEnumerable<PaiMing>> RKpaimingAsync()
        {
            return await or.RKpaimingAsync();
        }
        /// <summary>
        /// 出库排名
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        [HttpGet]

        public async Task<IEnumerable<PaiMing>> CKpaimingAsync()
        {
            return await or.CKpaimingAsync();
        }
    }
}
