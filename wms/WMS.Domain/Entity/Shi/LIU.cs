using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Shi
{
    public class LIU
    {
      
        public int inbill_code { get; set; }
        public int out1 { get; set; }
        public string item_code { get; set; }
        public string inbill_bh { get; set; }
        public string inbill_type { get; set; }
        public DateTime inbll_date { get; set; }
        public string create_by { get; set; }
        public string inbill_duty_man { get; set; }
        public string ware_name { get; set; }
        public Decimal inbill_num { get; set; }
        public Decimal outbill_num { get; set; }
        public Decimal zong { get; set; }
        public Decimal czong { get; set; }
        public DateTime create_time { get; set; }
    

    }
}
