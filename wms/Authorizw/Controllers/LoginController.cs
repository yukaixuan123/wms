
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http.Json;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using WMS.AppService.AppService;
using WMS.Domain.Entity;
using WMS.Domain.Entity.User;

namespace Authorize.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly IUsersAppService usersAppService;

        public LoginController(IUsersAppService usersAppService) 
        {
            this.usersAppService = usersAppService;
        }

        [HttpGet]
        public  async Task<JsonResult> Login(string name,string pwd)
        {
            string mm = MMJM.GetPwd(pwd);
         Users users= usersAppService.LoginUsers(name, mm);
            if (users!=null)
            {
                //准备有效载荷
                var claims = new Claim[] {
                    new Claim("UserId","123456"),
                    new Claim(ClaimTypes.Name,users.U_name)
                };
                //读取加密key
                SymmetricSecurityKey key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("SDMC-CJAS1-SAD-DFSFA-SADHJVF-VFSS"));
                //指定加密算法
                SigningCredentials signingCredentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
                //创建jwt
                JwtSecurityToken jwtSecurityToken = new JwtSecurityToken(
                    issuer: "http://localhost:5268",//颁发Token的web应用程序地址(当前程序)
                    audience: "http://localhost:5149",//token接收程序的地址(WebApi)
                    claims: claims,
                    expires: DateTime.Now.AddMinutes(1),//1分钟有效
                    signingCredentials: signingCredentials);
                //生成jwt字符串
                var token = new JwtSecurityTokenHandler().WriteToken(jwtSecurityToken);

                Dictionary<string, object> data = new Dictionary<string, object>();
                data.Add("u_id", users.U_id);
                data.Add("u_name", users.U_name);
                data.Add("u_True_name",users.U_True_name);
                
                data.Add("token", token);
                IEnumerable<object> rights = await usersAppService.GetTrees(users.U_id);


                Dictionary<string, object> result = new Dictionary<string, object>();
                result.Add("data", data);
                result.Add("roles", rights);

                string json = JsonConvert.SerializeObject(result);
                return  new JsonResult(result);
                
            }
            else
            {
                return new JsonResult("3");
            }
        }

        

       
    }
}
