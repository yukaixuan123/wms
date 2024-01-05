using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Wh;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 进货明细
    /// </summary>
    internal class Wh_orderbuy_dConfiger : IEntityTypeConfiguration<Wh_orderbuy_d>
    {
        public void Configure(EntityTypeBuilder<Wh_orderbuy_d> builder)
        {
            builder.ToTable(nameof(Wh_orderbuy_d));
            builder.HasKey(e => e.buy_codeId);
            builder.Property(e => e.buy_code).HasColumnType("char(16)").IsRequired();
            builder.Property(e => e.item_name).HasMaxLength(100).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.item_code).HasMaxLength(80).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.model_code).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.unit).HasMaxLength(30).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.item_type_name).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.buy_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.inbill_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.return_goods_num).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.buy_goods_money).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired(false);

        }
    }
}
