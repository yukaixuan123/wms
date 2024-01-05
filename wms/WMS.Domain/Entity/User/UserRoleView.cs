using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.UserRoleView
{
    public class UserRoleView
    {
    public int u_id { get; set; }
        public string U_name { get; set; }

        public string U_True_name { get; set; }

        public string U_password { get; set; }

        public string U_State { get; set; }

        public string is_del { get; set; }

        public int RolesID { get; set; }

        public string RolesName { get; set; }

        public int UserRolesID { get; set; }

    }
}
