using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;

namespace WMS.Domain.Repository.Sup
{
    public interface ISupplyViewRepository
    {
        //供应商管理分页查询
        Task<FenYeSupply<SupplyView>> FenYeAsync(int page, int pageSize,string str);
        //供应商管理逻辑删除
        Task<bool> SupplyDeleteAsync(int id, string bl);
        //供应商管理批量删除
        Task<bool> PLDeleteSupply(int[] num);
        //供应商管理添加
        Task<bool> SupplyInsertAsync(string code, string name, string type, string typecode, string man, string tel, string yx, string sdman, string zt, string adr, string cz, string bz);
        //银行添加
        Task<bool> FinanceInsertAsync(Bs_finance bs_Finance);
        //所属行业下拉框
        Task<IEnumerable<Bs_supply>> HYAsync();
        //供应商分类下拉框
        Task<IEnumerable<Bs_supply>> FLAsync();
        //当前用户
        Task<Users> UsersID(string username, string password);
        //根据id查全部
        Task<SupplyView> SelectIDAsync(int id);
        //供应商管理修改
        Task<bool> SupplyUpdateAsync(string code, string name, string type, string typecode, string man, string tel, string yx, string fz, string zt, string adr, string cz, string bz, int id);
        //银行修改
        Task<bool> FinanceUpdateAsync(Bs_finance bs_Finance,int id);
        //供应商名称是否存在
        Task<int> SupplyNameAsync(string name);
        Task<SupplyView> SelectCodeAsync(string id);
        Task<IEnumerable<Users>> CzrAsync();
        Task<FenYeSupply<gysRK>> FenYegysRKAsync(int page, int pageSize, string str);
    }
}
