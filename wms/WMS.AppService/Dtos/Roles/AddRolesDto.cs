using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.AppService.Dtos.Roles
{
    public class AddRolesDto
    {
        public string RolesName { get; set; }

        public string RolesAuthority { get; set; }

        public string RolesState { get; set; }
    }
}
