using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Ku;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 出库管理表
    /// </summary>
    internal class Wh_outbill_hConfiger : IEntityTypeConfiguration<Wh_outbill_h>
    {
        public void Configure(EntityTypeBuilder<Wh_outbill_h> builder)
        {
            builder.ToTable(nameof(Wh_outbill_h));
            builder.HasKey(e => e.outbill_h_id);
            builder.Property(e => e.outbill_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.outbill_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.outbill_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.sale_code).HasColumnType("char(16)").IsRequired(false);
            builder.Property(e => e.cust_code).HasColumnType("char(8)").IsRequired(false);
            builder.Property(e => e.link_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.link_way).HasMaxLength(50).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.duty_man).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.ware_code).HasMaxLength(8).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_time).HasColumnType("datetime");
            builder.Property(e => e.sure_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.sure_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sure_date).HasColumnType("datetime");
        }
    }
}
