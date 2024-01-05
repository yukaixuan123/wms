using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Cm
{
    public class CkST
    {
        public int outbill_h_id { get; set; }
        public string outbill_code { get; set; }
        public string ware_code { get; set; }
        public string cust_code { get; set; }
        public string outbill_type { get; set; }
        public string outbill_state { get; set; }
        public string outbill_date { get; set; }
        public string sale_code { get; set; }
        public string duty_man { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
        public string create_by { get; set; }
        public string link_man { get; set; }
        public string link_way { get; set; }

        public Decimal inbill_num { get; set; }


        public Decimal outbill_num { get; set; }
        public Decimal zong { get; set; }

        public string names { get; set; }
        public DateTime create_time { get; set; }

        public string item_code { get; set; }
    }
}
