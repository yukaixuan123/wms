using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Cm
{
    public class RkST
    {
        [Key]
        public int inbill_code { get; set; }
        public string ware_name { get; set; }
        public string inbill_bh { get; set; }
        public string inbill_type { get; set; }
        public string inbill_state { get; set; }
        public DateTime inbll_date { get; set; }
        public string buy_code { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }

        public Decimal inbill_num { get; set; }

        public Decimal zong { get; set; }

        public string names { get; set; }
        public string inbill_duty_man { get; set; }

        public string item_code { get; set; }
    }
}
