using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.User
{
    /// <summary>
    /// 角色表
    /// </summary>
    public class Roles
    {
        //RolesID, RolesName, RolesInstruction, RolesIf

        public int RolesID { get; set; }

        public string RolesName  { get; set; }

        public string RolesAuthority { get; set; }

        public string RolesState { get; set; }
    }
}
