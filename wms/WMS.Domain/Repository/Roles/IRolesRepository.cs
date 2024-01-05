using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.User;

namespace WMS.Domain.Repository
{
    public interface IRolesRepository
    {
        FenYe<Roles> Find(int page, int pageSize, string gw, string zt);

        Task<bool> UpdateRolesState(int roleId, string u_State);
        //树状查询
        Task<IEnumerable<Trees>> GetTrees();
        //查询权限
        int[] GetQuan(int RolesID);

        Task<bool> DeleteRoles(int roleId);
        //权限修改
        Task<bool> UpdateRoles(int roleId, int pid);

        List<RolesAuthority> GetRolesId(int RolesID);

        Task<FenYeUsers<Authority>> FindAuthority(int pageSize, int CurrentPage, string str);

        Task<IEnumerable<AuthorityCascader>> AuthorityGetCascader();

        Task<bool> AddAuthority(Authority  authority);

        Task<bool> UpdateAuthority(Authority authority);

        Task<bool> DeleteAuthority(int aid);

        Task<bool> AddRoles(Roles roles);

        List<Roles> FindRoles();

        Task<bool> RemoveRoles(int roleId);


    }
}
