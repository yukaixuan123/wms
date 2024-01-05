using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.User;

namespace WMS.Domain.Entity.Cm
{
    public class GoodsCascader
    {
        public int item_type_id { get; set; }

        public string item_type_code { get; set; }
        public string value { get; set; }

        public string label { get; set; }

        public string pid { get; set; }


        public int sort_code { get; set; }

        public string inbill_state { get; set; }

        public string remark { get; set; }

        public string create_by { get; set; }

        public DateTime create_time { get; set; }

        public List<GoodsCascader> children { get; set; }



      
    }
}
