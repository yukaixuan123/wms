using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.User
{
    /// <summary>
    /// 用户表
    /// </summary>
    public class Users
    {
       
        public int U_id { get; set; }

        public string U_name { get; set; }

        public string U_True_name { get; set; }

        public string U_password { get; set; }

        public string U_State { get; set; }

        public string  is_del { get; set; }

        

    }
}
