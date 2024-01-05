using Microsoft.AspNetCore.Mvc;
using WMS.AppService.AppService.Sup;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity;
using WMS.Domain.Entity.User;

namespace WMS.Controllers.Sup
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class CustomerViewController : Controller
    {
        private readonly ICustomerViewService customerViewService;
        public CustomerViewController(ICustomerViewService customerViewService)
        {
            this.customerViewService = customerViewService;
        }
        /// <summary>
        /// 客户管理分页查询
        /// </summary>
        /// <param name="currentPage">总页数</param>
        /// <param name="pageSize">总条数</param>
        /// <param name="str">查询条件</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<FenYeSupply<CustomerView>> FenYeCustomerAsync(int currentPage, int pageSize, string str)
        {
            return await customerViewService.FenYeCustomerAsync(currentPage, pageSize, str);
        }
        /// <summary>
        /// 客户管理逻辑删除
        /// </summary>
        /// <param name="id">客户id</param>
        /// <param name="str">条件</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<bool> CustomerDeleteAsync(int id,string str)
        {
            return await customerViewService.CustomerDeleteAsync(id, str);
        }
        /// <summary>
        /// 客户管理批量删除
        /// </summary>
        /// <param name="num">数组</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> PLDeleteCustomer([FromBody] int[] num)
        {
            return await customerViewService.PLDeleteCustomer(num);
        }
        /// <summary>
        /// 当前用户
        /// </summary>
        /// <param name="username">用户名</param>
        /// <param name="password">密码</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<Users> UsersID(string username,string password)
        {
            return await customerViewService.UsersID(username, password);
        }

        /// <summary>
        /// 银行添加
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<bool> FinanceInsertAsync(Bs_finance bs_Finance)
        {
            return await customerViewService.FinanceInsertAsync(bs_Finance);
        }
        /// <summary>
        /// 客户管理添加
        /// </summary>
        /// <param name="bs_Customer">客户实体类</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<bool> CustomerInsertAsync(string code, string name, string man, string tel, string yx, string adr, string zt, string from, string fz, string type, string cz, string bz)
        {
            return await customerViewService.CustomerInsertAsync(code,name,man,tel,yx,adr,zt,from,fz,type,cz,bz);
        }
        /// <summary>
        /// 客户来源下拉框
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public async Task<IEnumerable<Bs_customer>> LYAsync()
        {
            return await customerViewService.LYAsync();
        }
        /// <summary>
        /// 所属行业下拉框
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public async Task<IEnumerable<Bs_customer>> HYAsync()
        {
            return await customerViewService.HYAsync();
        }
        /// <summary>
        /// 根据id查全部
        /// </summary>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<CustomerView> SelectIDAsync(int id)
        {
            return await customerViewService.SelectIDAsync(id);
        }
        /// <summary>
        /// 客户管理修改
        /// </summary>
        /// <param name="code">客户编码</param>
        /// <param name="name">客户名称</param>
        /// <param name="type">所属行业</param>
        /// <param name="from">客户来源</param>
        /// <param name="man">联系人</param>
        /// <param name="tel">联系电话</param>
        /// <param name="yx">邮箱</param>
        /// <param name="fz">销售负责人</param>
        /// <param name="zt">状态</param>
        /// <param name="adr">客户地址</param>
        /// <param name="cz">操作人</param>
        /// <param name="bz">备注</param>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> CustomerUpdateAsync(string code, string name, string type, string from, string man, string tel, string yx, string fz, string zt, string adr, string cz, string bz, int id)
        {
            return await customerViewService.CustomerUpdateAsync(code, name, type, from, man, tel, yx, fz, zt, adr, cz, bz, id);
        }
        /// <summary>
        /// 银行修改
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        [HttpPut]
        public async Task<bool> FinanceUpdateAsync(Bs_finance bs_Finance,int id)
        {
            return await customerViewService.FinanceUpdateAsync(bs_Finance,id);
        }
        /// <summary>
        /// 客户名称是否存在
        /// </summary>
        /// <param name="name">客户名称</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<int> CustomerNameAsync(string name)
        {
            return await customerViewService.CustomerNameAsync(name);
        }
        [HttpGet]
        public async Task<CustomerView> SelectCodeAsync(string id)
        {
            return await customerViewService.SelectCodeAsync(id);
        }
        [HttpGet]
        public async Task<FenYeSupply<khCK>> FenYekhCKAsync(int currentPage, int pageSize, string str)
        {
            return await customerViewService.FenYekhCKAsync(currentPage, pageSize, str);
        }
    }
}
