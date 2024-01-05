using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WMS.Domain.Entity.Wh
{
    /// <summary>
    /// 进货退货表
    /// </summary>
    public class Wh_return_supply_h
    {
        public int buy_codeId { get; set; }
        public string returns_code { get; set; }
        public string buy_code { get; set; }
        public string sale_state { get; set; }
        public DateTime sr_date { get; set; }
        public string supply_code { get; set; }
        public string link_man { get; set; }
        public string link_way { get; set; }
        public string buy_man { get; set; }
        public Decimal returns_num { get; set; }
        public Decimal returns_money { get; set; }
        public Decimal buy_price { get; set; }
        public string remark { get; set; }
        public string remarks { get; set; }
        public string create_by { get; set; }
        public DateTime create_time { get; set; }
        public DateTime? update_time { get; set; }
        public string update_by { get; set; }
        public string sure_state { get; set; }
        public string sure_man { get; set; }
        public DateTime sure_date { get; set; }
        public string sure_yj { get; set; }
        public string is_del { get; set; }
    }
}
