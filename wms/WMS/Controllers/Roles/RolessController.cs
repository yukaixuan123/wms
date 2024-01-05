using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WMS.AppService.AppService;
using WMS.AppService.AppService.Bs;
using WMS.AppService.AppService.Cm;
using WMS.AppService.Dtos.Roles;
using WMS.Domain.Entity;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.UserRoleView;

namespace WMS.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class RolessController : ControllerBase
    {
        private readonly IRolesAppService bs;
        public RolessController(IRolesAppService bs)
        {
            this.bs = bs;
        }

        [HttpGet]
        public IActionResult RolesFind(int page, int pageSize, string gw = "", string zt = "")
        {

            var pp = bs.Find(page,pageSize,gw,zt);
            return Ok(pp);
        }

        //修改状态
        [HttpPut]
        public async Task<bool> UpdateRolessStateAsync(int roleId, string roleState)
        {
            return await bs.UpdateRolesState(roleId, roleState);
        }
        //树状查询
        [HttpGet]
        public Task<IEnumerable<Trees>> GetTrees()
        {
            return bs.GetTrees();
        }
        [HttpGet]
        //权限查询
        public int[] GetQuan(int RoelsId)
        {
            return bs.GetQuan(RoelsId);
        }
        [HttpPut]

        //权限修改
        public async Task<bool> UpdateRoles(int roleId, int pid)
        {
            return await bs.UpdateRoles(roleId, pid);
        }
        [HttpDelete]
        //权限删除
        public async Task<bool> DeleteRoles(int roleId)
        {
            return await bs.DeleteRoles(roleId);
        }
        [HttpGet]

        public List<RolesAuthority> GetRolesById(int RolesID)
        {
            return bs.GetRolesId(RolesID);
        }

        [HttpGet]
        public async Task<FenYeUsers<Authority>> FindAuthority(int PageSize, int CurrentPage, string str)
        {
            return await bs.FindAuthority(PageSize, CurrentPage, str);
        }

        [HttpGet]
        public async Task<IEnumerable<AuthorityCascader>> GetAuthorities()
        {
            return await bs.AuthorityGetCascader();
        }

        //权限insert
        [HttpPost]
        public async Task<bool> AddAuthority(AddAuthorityDto addAuthorityDto)
        {
            return await bs.AddAuthority(addAuthorityDto);
        }
        //update
        [HttpPut]
        public async Task<bool> UpdateAuthority(UpdateAuthorityDto updateAuthorityDto)
        {
            return await bs.UpdateAuthority(updateAuthorityDto);
        }
        [HttpDelete]
        public async Task<bool> DeleteAuthority(int aid)
        {
            return await bs.DeleteAuthority(aid);
        }
        [HttpPost]

        public async Task<bool>AddRoles(AddRolesDto addRolesDto)
        {
            return await bs.AddRoles(addRolesDto);
        }

        [HttpGet]
        public List<Roles> FindRoles()
        {
            return bs.FindRoles();
        }

        [HttpDelete]
        public async Task<bool> RemoveRoles(int roleId)
        {
            return await bs.RemoveRoles(roleId);
        }
    }
}
