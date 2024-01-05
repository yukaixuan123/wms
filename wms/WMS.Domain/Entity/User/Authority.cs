using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.User
{
    /// <summary>
    /// 权限
    /// </summary>
    public class Authority
    {
        //RolesJID, RolesID, JuriID

        public int AuthorityID { get; set; }

        public string AuthorityName { get; set; }

        public int GroupID { get; set; }

        public string AuthorityAddress { get; set; }

        public int Pid { get; set; }
    }
}
