using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Wh;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 进货订单表
    /// </summary>
    internal class Wh_buy_order_hConfiger : IEntityTypeConfiguration<Wh_buy_order_h>
    {
        public void Configure(EntityTypeBuilder<Wh_buy_order_h> builder)
        {
            builder.ToTable(nameof(Wh_buy_order_h));
            builder.HasKey(e => e.buy_codeId);
            builder.Property(e => e.buy_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.buy_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.supply_code).HasColumnType("char(9)").IsRequired(false);
            builder.Property(e => e.link_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.link_way).HasMaxLength(50).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.buy_man).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.update_time).HasColumnType("datetime");
            builder.Property(e => e.update_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sure_state).HasColumnType("char(1)").IsRequired(false);
            builder.Property(e => e.sure_man).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.sure_date).HasColumnType("datetime").IsRequired();
            builder.Property(e => e.remark).HasMaxLength(500).IsUnicode(false).IsRequired(false);
        }
    }
}
