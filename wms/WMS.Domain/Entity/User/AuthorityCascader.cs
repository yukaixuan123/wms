using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.User
{
    public class AuthorityCascader
    {
        public int value { get; set; }

        public string label { get; set; }

        public int pid { get; set; }
        public List<AuthorityCascader> children { get; set; }

    }
}
