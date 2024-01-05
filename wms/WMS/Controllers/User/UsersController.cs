using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using WMS.AppService.AppService;
using WMS.AppService.Dtos.Users;
using WMS.Domain.Entity;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.UserRoleView;
using WMS.EFCore;

namespace WMS.Controllers.User
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IUsersAppService users;

        public UsersController(IUsersAppService users)
        {
            this.users = users;
        }
        [HttpGet]

        public IActionResult UsersFenYeAsync(int page, int pageSize, string zh = null, string xm = null, string zt = null)
        {
            var products = users.UsersSelectAsync(page, pageSize, zh, xm, zt);

            return Ok(products);
        }


        [HttpGet]


        public async Task<FenYeUsers<UserRoleView>> FindUser(int PageSize, int CurrentPage, string str)
        {
            return await users.FindUser(PageSize, CurrentPage, str);
        }

        [HttpPut]
        public async Task<bool> UpdateUsersStateAsync(int u_id, string u_State)
        {
            return await users.UpdateUsersState(u_id, u_State);
        }

        [HttpPost]
        public async Task<int> AddUsers(string u_name, string U_True_name, string U_password, string U_State, string is_del, int rolesId)
        {
            return await users.AddUsers(u_name, U_True_name, U_password, U_State, is_del,rolesId);
        }

        [HttpPut]
        public async Task<int> UpdateUsers(string u_name, string U_True_name, string U_password, int rolesId, int u_id, int UserRolesID)
        {
            return await users.UpdateUsers(u_name,U_True_name, U_password, rolesId, u_id, UserRolesID);
        }

        [HttpPut]
        public async Task<bool> DeleteUsers(int u_id, string is_del)
        {
            return await users.DeleteUsers(u_id, is_del);
        }
    }
}
