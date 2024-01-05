using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.AppService.Dtos.Roles
{
    public class UpdateAuthorityDto
    {
        public int AuthorityID { get; set; }

        public string AuthorityName { get; set; }


        public string AuthorityAddress { get; set; }

        public int Pid { get; set; }
    }
}
