using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Roles;
using WMS.Domain.Entity;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.UserRoleView;

namespace WMS.AppService.AppService
{
    public interface IRolesAppService
    {
        FenYe<Roles> Find(int page, int pageSize, string gw,string zt);

        //角色状态修改
        Task<bool> UpdateRolesState(int roleId, string u_State);

        //树状查询
        Task<IEnumerable<Trees>> GetTrees();

        int[] GetQuan(int RolesID);

        //权限删除
        Task<bool> DeleteRoles(int roleId);
        //权限修改
        Task<bool> UpdateRoles(int roleId, int pid);

        //查权限
        List<RolesAuthority> GetRolesId(int RolesID);


        //查询权限地址
        Task<FenYeUsers<Authority>> FindAuthority(int pageSize, int CurrentPage, string str);

        //查询级联地址
        Task<IEnumerable<AuthorityCascader>> AuthorityGetCascader();


        //添加权限表
        Task<bool> AddAuthority(AddAuthorityDto addAuthorityDto);

        //修改权限表
        Task<bool> UpdateAuthority(UpdateAuthorityDto updateAuthorityDto);

        //delete
        Task<bool> DeleteAuthority(int aid);

        Task<bool> AddRoles(AddRolesDto addRolesDto);

        List<Roles> FindRoles();

        //删除角色
        Task<bool> RemoveRoles(int roleId);

    }
}
