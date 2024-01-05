using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.User
{
    /// <summary>
    /// 用户角色
    /// </summary>
    public class UserRoles
    {
        //UserRolesID, UserID, RolesID
        public int UserRolesID { get; set; }

        public int UserID { get; set; }

        public int RolesID { get; set; }
    }
}
