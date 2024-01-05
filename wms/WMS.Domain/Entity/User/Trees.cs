using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.User
{
    public class Trees
    {
        public int id { get; set; }
        public int pid { get; set; }
        public string text { get; set; }
        public string url { get; set; }
        public List<Trees> children { get; set; }

       
    }
}
