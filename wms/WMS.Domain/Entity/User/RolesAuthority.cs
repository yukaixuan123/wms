using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.User
{
   
    /// <summary>
    /// 角色权限
    /// </summary>
    public class RolesAuthority
    {
        public int RolesAuthorityID { get; set; }

        public int RolesID { get; set; }

        public int AuthorityID { get; set; }
    }
}
