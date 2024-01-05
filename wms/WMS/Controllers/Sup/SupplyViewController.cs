using Microsoft.AspNetCore.Mvc;
using Microsoft.Identity.Client;
using WMS.AppService.AppService.Cm;
using WMS.AppService.AppService.Sup;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;

namespace WMS.Controllers.Sup
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class SupplyViewController : Controller
    {
        private readonly ISupplyViewService supplyViewService;
        public SupplyViewController(ISupplyViewService supplyViewService)
        {
            this.supplyViewService = supplyViewService;
        }
        /// <summary>
        /// 供应商管理分页查询
        /// </summary>
        /// <param name="currentPage">总页数</param>
        /// <param name="pageSize">总条数</param>
        /// <param name="str">查询条件</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<FenYeSupply<SupplyView>> FenYeAsync(int currentPage, int pageSize, string str)
        {
            return await supplyViewService.FenYeAsync(currentPage, pageSize, str);
        }
        /// <summary>
        /// 供应商管理逻辑删除
        /// </summary>
        /// <param name="id">供应商id</param>
        /// <param name="bl">条件</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<bool> SupplyDeleteAsync(int id,string bl)
        {
            return await supplyViewService.SupplyDeleteAsync(id, bl);
        }
        /// <summary>
        /// 供应商管理批量删除
        /// </summary>
        /// <param name="num">数组</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> PLDeleteSupply([FromBody] int[] num)
        {
            return await supplyViewService.PLDeleteSupply(num);
        }
        /// <summary>
        /// 供应商管理添加
        /// </summary>
        /// <param name="bs_Supply">供应商实体类</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<bool> SupplyInsertAsync(string code, string name, string type, string typecode, string man, string tel, string yx, string sdman, string zt, string adr, string cz, string bz)
        {
            return await supplyViewService.SupplyInsertAsync(code,name,type,typecode,man,tel,yx,sdman,zt,adr,cz,bz);
        }
        /// <summary>
        /// 银行添加
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<bool> FinanceInsertAsync(Bs_finance bs_Finance)
        {
            return await supplyViewService.FinanceInsertAsync(bs_Finance);
        }
        /// <summary>
        /// 所属行业下拉框
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public async Task<IEnumerable<Bs_supply>> HYAsync()
        {
            return await supplyViewService.HYAsync();
        }
        /// <summary>
        /// 供应商分类下拉框
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public async Task<IEnumerable<Bs_supply>> FLAsync()
        {
            return await supplyViewService.FLAsync();
        }
        /// <summary>
        /// 当前用户
        /// </summary>
        /// <param name="username">用户名</param>
        /// <param name="password">密码</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<Users> UsersID(string username, string password)
        {
            return await supplyViewService.UsersID(username, password);
        }
        /// <summary>
        /// 根据id查全部
        /// </summary>
        /// <param name="id">供应商id</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<SupplyView> SelectIDAsync(int id)
        {
            return await supplyViewService.SelectIDAsync(id);
        }
        /// <summary>
        /// 供应商管理修改
        /// </summary>
        /// <param name="code">供应商编码</param>
        /// <param name="name">供应商名称</param>
        /// <param name="type">所属行业</param>
        /// <param name="typecode">供应商分类</param>
        /// <param name="man">联系人</param>
        /// <param name="tel">联系电话</param>
        /// <param name="yx">邮箱</param>
        /// <param name="fz">进货负责人</param>
        /// <param name="zt">状态</param>
        /// <param name="adr">供应商地址</param>
        /// <param name="cz">操作人</param>
        /// <param name="bz">备注</param>
        /// <param name="id">供应商id</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> SupplyUpdateAsync(string code, string name, string type, string typecode, string man, string tel, string yx, string fz, string zt, string adr, string cz, string bz, int id)
        {
            return await supplyViewService.SupplyUpdateAsync(code,name,type,typecode,man,tel,yx,fz,zt,adr,cz,bz,id);
        }
        /// <summary>
        /// 银行修改
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <param name="id">供应商id</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> FinanceUpdateAsync(Bs_finance bs_Finance,int id)
        {
            return await supplyViewService.FinanceUpdateAsync(bs_Finance,id);
        }
        /// <summary>
        /// 供应商名称是否存在
        /// </summary>
        /// <param name="name">供应商名称</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<int> SupplyNameAsync(string name)
        {
            return await supplyViewService.SupplyNameAsync(name);
        }
        [HttpGet]
        public async Task<SupplyView> SelectCodeAsync(string id)
        {
            return await supplyViewService.SelectCodeAsync(id);
        }
        //[HttpGet]
        //public async Task<SupXQ> SelectSupXQ(string name)
        //{
        //    return await supplyViewService.SelectSupXQ(name);
        //}
        [HttpPost]
        public async Task<IEnumerable<Users>> CzrAsync()
        {
            return await supplyViewService.CzrAsync();
        }
        [HttpGet]
        public async Task<FenYeSupply<gysRK>> FenYegysRKAsync(int page, int pageSize, string str)
        {
            return await supplyViewService.FenYegysRKAsync(page, pageSize, str);
        }
    }
}
