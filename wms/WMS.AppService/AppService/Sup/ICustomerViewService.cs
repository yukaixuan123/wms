using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;

namespace WMS.AppService.AppService.Sup
{
    public interface ICustomerViewService
    {
        //客户管理分页查询
        Task<FenYeSupply<CustomerView>> FenYeCustomerAsync(int page,int pageSize,string str);
        //客户管理逻辑删除
        Task<bool> CustomerDeleteAsync(int id, string str);
        //客户管理批量删除
        Task<bool> PLDeleteCustomer(int[] num);
        //银行添加
        Task<bool> FinanceInsertAsync(Bs_finance bs_Finance);
        //客户管理添加
        Task<bool> CustomerInsertAsync(string code, string name, string man, string tel, string yx, string adr, string zt, string from, string fz, string type, string cz, string bz);
        //当前用户
        Task<Users> UsersID(string username, string password);
        //客户来源下拉框
        Task<IEnumerable<Bs_customer>> LYAsync();
        //所属行业下拉框
        Task<IEnumerable<Bs_customer>> HYAsync();
        //根据id查全部
        Task<CustomerView> SelectIDAsync(int id);
        //客户管理修改
        Task<bool> CustomerUpdateAsync(string code, string name, string type, string from, string man, string tel, string yx, string fz, string zt, string adr, string cz, string bz, int id);
        //银行修改
        Task<bool> FinanceUpdateAsync(Bs_finance bs_Finance, int id);
        //客户名称是否存在
        Task<int> CustomerNameAsync(string name);
        Task<CustomerView> SelectCodeAsync(string id);
        Task<FenYeSupply<khCK>> FenYekhCKAsync(int currentPage, int pageSize, string str);
    }
}
