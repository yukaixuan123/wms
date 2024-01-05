using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Sup
{
    public class khCK
    {
        public string outbill_code { get; set; }
        public string outbill_type { get; set; }
        public DateTime outbill_date { get; set; }
        public string ware_code { get; set; }
        public Decimal outbill_num { get; set; }
        public Decimal zong { get; set; }
        public string duty_man { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public string cust_code { get; set; }
        [Key]
        public int outbill_h_id { get; set; }
    }
}
